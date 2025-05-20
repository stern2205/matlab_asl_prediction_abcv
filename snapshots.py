import cv2
import os

# === Settings ===
num_images = 300
box_size = 480
output_folder = "snapshots"

# Create output folder if it doesn't exist
os.makedirs(output_folder, exist_ok=True)

# Start webcam
cap = cv2.VideoCapture(0)

if not cap.isOpened():
    print("Error: Cannot access the webcam.")
    exit()

count = 0
print("Capturing 480x480 images... Press 'q' to quit early.")

while count < num_images:
    ret, frame = cap.read()
    if not ret:
        print("Failed to grab frame.")
        break

    height, width, _ = frame.shape

    if width < box_size or height < box_size:
        print(f"Error: Frame too small for {box_size}x{box_size} crop. Got {width}x{height}.")
        break

    # Center crop coordinates
    center_x, center_y = width // 2, height // 2
    half = box_size // 2
    x1 = center_x - half
    y1 = center_y - half
    x2 = center_x + half
    y2 = center_y + half

    # Crop and save
    cropped = frame[y1:y2, x1:x2]
    filename = os.path.join(output_folder, f"img_{count:03d}.jpg")
    cv2.imwrite(filename, cropped)
    count += 1

    # Display live feed with crop box
    cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 255, 0), 2)
    cv2.imshow("Webcam Feed", frame)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        print("Early exit triggered.")
        break

print(f"\nDone! {count} images saved in '{output_folder}'.")
cap.release()
cv2.destroyAllWindows()