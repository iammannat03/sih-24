"""
This is an Instagram Runner script.

Needs a Secrets file (Username and password)
Needs a hashkey file (search values)
"""
import pandas as pd
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from random_user_agent.user_agent import UserAgent
from random_user_agent.params import SoftwareName, OperatingSystem
import time
from selenium.common.exceptions import NoSuchElementException, ElementClickInterceptedException
from selenium.webdriver.common.by import By

import random

class IG_Bot_Creation:
    """Class creation for the bot itself."""

    def __init__(self, username, password, ProxyList) -> None:
        """Initialize the bot."""
        software_names = [SoftwareName.CHROME.value]
        operating_systems = [OperatingSystem.WINDOWS.value,
                             OperatingSystem.LINUX.value]
        user_agent_rotator = UserAgent(software_names=software_names,
                                       operating_systems=operating_systems,
                                       limit=100)
        # Getting a random user agent
        # Changing up the user identifier.
        user_agent = user_agent_rotator.get_random_user_agent()
        chrome_options = Options()
        # Won't physically open a browser on my machine.
        # chrome_options.add_argument("--headless")
        # Only way to get chromedriver to open headlessly (ignore firefox)
        chrome_options.add_argument("--no-sandbox")
        # Apparently needed for window machines
        chrome_options.add_argument("--disable-gpu")
        chrome_options.add_argument(f"user-agent={user_agent}")
        path = r'/Users/mannatjaiswal/SeleniumDrivers/chromedriver-mac-arm64/chromedriver'
        service = Service(executable_path=path)
        self.driver = webdriver.Chrome(service=service, options=chrome_options)
        self.driver.get('https://Instagram.com')
        self.driver.maximize_window()

    def login(self) -> None:
        """Login to Instagram using the secrets file."""
        time.sleep(2)
        # username setting
        self.username = username
        # //*[@id="loginForm"]/div/div[1]/div/label/input
        username_path='//*[@id="loginForm"]/div/div[1]/div/label/input'
        # username_path = '//*[@id="react-root"]/section/main/article/div[2]/div[1]/div/form/div[2]/div/label/input'
        self.driver.find_element(By.XPATH, username_path).send_keys(username)

        time.sleep(2)
        # Password setting
        self.password = password
        # //*[@id="loginForm"]/div/div[2]/div/label/input
        # password_path = '//*[@id="react-root"]/section/main/article/div[2]/div[1]/div/form/div[3]/div/label/input'
        password_path='//*[@id="loginForm"]/div/div[2]/div/label/input'
        self.driver.find_element(By.XPATH, password_path).send_keys(password)
        # //*[@id="loginForm"]/div/div[3]/button
        # login_path = '//*[@id="react-root"]/section/main/article/div[2]/div[1]/div/form/div[4]/button'
        login_path='//*[@id="loginForm"]/div/div[3]/button'
        self.driver.find_element(By.XPATH, login_path).click()
        time.sleep(2)
        # Get out of the notifications
        # self.driver.find_elements("xpath", "//button[contains(text(), 'Not Now')]")[0].click()
        # time.sleep(1)
        # Other notifications (second screen that popped up)
        # self.driver.find_element(By.XPATH, "//*[contains(@class, 'aOOlW   HoLwm ')]").click()


proxies=[]

if __name__ == "__main__":
    d = pd.read_csv('Secret.txt', header=None)
    username = d.iloc[0][0]
    password = d.iloc[1][0]
    # Passing in Username and Password and List of proxies to potentially use
    bot = IG_Bot_Creation(username, password, proxies)
    bot.login()
    time.sleep(2)
    # bot.Follow_Home_List_People(5)
    # bot.driver.get('https://Instagram.com/explore/tags/mountain/')
    # bot.evaluatePost(5)
# ss
