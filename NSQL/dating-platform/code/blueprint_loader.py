import importlib
import os
from pathlib import Path
from types import ModuleType
from flask import Flask
import logging
from app_builder import InitializationError

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class BlueprintLoader:
    def __init__(self, app: Flask):
        self._app = app

    def load_blueprints(self):
        try:
            blueprints = self._get_blueprints()
            for module_name in blueprints:
                module = importlib.import_module(module_name)
                self._register_blueprint(module)
        except Exception as e:
            raise InitializationError("Blueprints", str(e))

    def _get_blueprints(self):
        routes_dir = Path(__file__).parent / "routes"
        files = os.listdir(routes_dir)
        python_files = filter(
            lambda file: file.endswith(".py") and file != "__init__.py", files
        )
        blueprint_modules = [
            f"routes.{route_file.removesuffix('.py')}" for route_file in python_files
        ]
        return blueprint_modules

    def _register_blueprint(self, module: ModuleType):
        if hasattr(module, "blueprint"):
            blueprint = getattr(module, "blueprint")
            self._app.register_blueprint(blueprint)
            logger.info(f"Blueprint {module.__name__} registered.")
        else:
            logger.warning(f"No blueprint found in module {module.__name__}")
