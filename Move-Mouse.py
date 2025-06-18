import pyautogui
import time

pyautogui.FAILSAFE = False

center_x, center_y = 500, 500
offset = 100

try:
    while True:
        # Move in "+" pattern
        pyautogui.moveTo(center_x, center_y, duration=0.3)
        pyautogui.moveTo(center_x, center_y - offset, duration=0.3)
        pyautogui.moveTo(center_x, center_y, duration=0.3)
        pyautogui.moveTo(center_x, center_y + offset, duration=0.3)
        pyautogui.moveTo(center_x, center_y, duration=0.3)
        pyautogui.moveTo(center_x - offset, center_y, duration=0.3)
        pyautogui.moveTo(center_x, center_y, duration=0.3)
        pyautogui.moveTo(center_x + offset, center_y, duration=0.3)
        pyautogui.moveTo(center_x, center_y, duration=0.3)
        # Simulate a harmless key press
        pyautogui.press('shift')
        # Wait 60 seconds before next move
        time.sleep(60)
except KeyboardInterrupt:
    print("Stopped by user.")
