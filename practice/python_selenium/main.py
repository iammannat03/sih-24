import os
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time

service = Service(executable_path="/Users/mannatjaiswal/SeleniumDrivers/chromedriver-mac-arm64/chromedriver")
driver = webdriver.Chrome(service=service)

driver.get('https://google.com')

WebDriverWait(driver, 5).until(EC.presence_of_element_located((By.CLASS_NAME,"gLFyf")))

input_element = driver.find_element(By.CLASS_NAME,"gLFyf")
input_element.clear()
input_element.send_keys("mannat jaiswal"+Keys.ENTER)

WebDriverWait(driver, 5).until(EC.presence_of_element_located((By.PARTIAL_LINK_TEXT,"Mannat Jaiswal")))

link = driver.find_element(By.PARTIAL_LINK_TEXT,"Mannat Jaiswal")
link.click()

try:
    # Increase the timeout to 20 seconds
    WebDriverWait(driver, 20).until(EC.presence_of_element_located((By.XPATH, "//*[@id='container']/div/div[1]")))
    print("Element found")
except TimeoutException:
    print("Element not found within the given time")

google_sign_in=driver.find_element(By.XPATH,"//*[@id='container']/div/div[1]")

google_sign_in.click()


WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.XPATH,"//*[contains(text(),'Vedant Amal')]")))

name=driver.find_element(By.XPATH,"//*[contains(text(),'Vedant Amal')]")
name.click()

time.sleep(10)

# driver.quit()
