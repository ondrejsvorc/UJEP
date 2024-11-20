from abc import ABC, abstractmethod
from typing import List


class Observer(ABC):
    @abstractmethod
    def update(self, notification: str):
        pass


class UserNotification(Observer):
    def __init__(self, user_id: str):
        self.user_id = user_id
        self.notifications = []

    def update(self, notification: str):
        self.notifications.append(notification)
        print(f"User {self.user_id} received notification: {notification}")


class NotificationService:
    def __init__(self):
        self._observers: List[Observer] = []

    def add_observer(self, observer: Observer):
        self._observers.append(observer)

    def remove_observer(self, observer: Observer):
        self._observers.remove(observer)

    def notify_observers(self, notification: str):
        for observer in self._observers:
            observer.update(notification)
