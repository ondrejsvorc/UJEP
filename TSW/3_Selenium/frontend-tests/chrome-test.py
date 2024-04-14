from datetime import datetime
import random
import unittest
from selenium import webdriver
from selenium.webdriver.common.by import By

# 1. Manuální testeři
# 2. Lepší manuální testeři - Postman
# 3. Automatizační tester - Selenium/Appium
# 4. Quality assurance (QA) - Excel (Test Scenario - N Test Cases)
# 5. Lead za QA - Test Strategy, Test Plans

# GitOps - CI/CD pipeline na testy


# XUnit standard
# Testový scénář s testovými případy
class ChromeTest(unittest.TestCase):
    # (Fixture)
    # Implicitně volána před začátkem vykonávání testů
    def setUp(self):
        self._driver = webdriver.Chrome()
        self._baseUrl = "http://localhost:8000"

    def test_first_pizza(self):
        self._driver.get(f"{self._baseUrl}/pizzas")
        first_pizza_li = self._driver.find_element(By.XPATH, "//ol/li[1]")

        self.assertTrue("Name: Margarita" in first_pizza_li.text)
        self.assertTrue("Price: 50" in first_pizza_li.text)

    def test_add_pizza(self):
        self._driver.get(f"{self._baseUrl}/add-pizza")

        new_pizza_name = f"Test_Pizza_{datetime.now()}"
        pizza_name_input = self._driver.find_element(By.NAME, "pizzaName")
        pizza_name_input.clear()
        pizza_name_input.send_keys(new_pizza_name)

        new_pizza_price = random.randint(100, 200)
        pizza_price_input = self._driver.find_element(By.NAME, "pizzaPrice")
        pizza_price_input.clear()
        pizza_price_input.send_keys(new_pizza_price)

        add_button_submit = self._driver.find_element(
            By.XPATH, "//input[@type='submit']"
        )
        add_button_submit.click()

        new_pizza_li = self._driver.find_element(By.XPATH, "//ol/li[last()]")

        self.assertTrue(f"Name: {new_pizza_name}" in new_pizza_li.text)
        self.assertTrue(f"Price: {new_pizza_price}" in new_pizza_li.text)

    def test_order_pizza(self):
        self._driver.get(f"{self._baseUrl}/order-pizza")

        pizza_name_input = self._driver.find_element(By.NAME, "pizzaName")
        pizza_name_input.clear()
        pizza_name_input.send_keys("Margarita")

        pizza_amount_input = self._driver.find_element(By.NAME, "pizzaAmount")
        pizza_amount_input.clear()
        pizza_amount_input.send_keys("5")

        order_button_submit = self._driver.find_element(
            By.XPATH, "//input[@type='submit']"
        )
        order_button_submit.click()

        invoice_path = "../invoice.txt"
        with open(invoice_path, "r") as invoice_file:
            self.assertTrue("Pay 250 $" in invoice_file.read())

    # Teardown
    # Implicitně volána po provedení všech testů
    def tearDown(self):
        self._driver.close()


if __name__ == "__main__":
    unittest.main()
