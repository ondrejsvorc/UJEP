from abc import ABC, abstractmethod
import importlib
import os
from pathlib import Path
from types import ModuleType
from flask import Flask
import logging
from app_builder import InitializationError

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class BlueprintLoader(ABC):
    def __init__(self, app: Flask):
        self._app = app

    def load_blueprints(self):
        try:
            blueprint_paths = self._get_blueprint_paths()
            self._load_blueprints(blueprint_paths)
        except Exception as e:
            raise InitializationError("Blueprints", str(e))

    @abstractmethod
    def _get_blueprint_paths(self) -> list[str]:
        pass

    def _load_blueprints(self, blueprint_paths: list[str]):
        for path in blueprint_paths:
            module = importlib.import_module(path)
            self._load_blueprint(module)

    def _load_blueprint(self, module: ModuleType):
        if hasattr(module, "blueprint"):
            blueprint = getattr(module, "blueprint")
            self._app.register_blueprint(blueprint)
            logger.info(f"Blueprint {module.__name__} registered.")
        else:
            logger.warning(f"No blueprint found in module {module.__name__}")


class FileBlueprintLoader(BlueprintLoader):
    def __init__(self, app: Flask):
        super().__init__(app)

    def _get_blueprint_paths(self) -> list[str]:
        routes_dir = Path(__file__).parent / "routes"
        files = os.listdir(routes_dir)
        python_files = filter(
            lambda file: file.endswith(".py") and file != "__init__.py", files
        )
        return [
            f"routes.{route_file.removesuffix('.py')}" for route_file in python_files
        ]
