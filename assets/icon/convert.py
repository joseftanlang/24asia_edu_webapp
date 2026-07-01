from PIL import Image

def convert_jpg_to_png(input_path, output_path):
    try:
        # Open the original 600x600 JPG image
        with Image.open(input_path) as img:
            # Confirm dimensions remain 600x600
            print(f"Original size: {img.size}") 
            
            # Save as PNG with maximum quality compression
            img.save(output_path, "PNG", optimize=True)
            print(f"Successfully saved suitable PNG to: {output_path}")
            
    except Exception as e:
        print(f"An error occurred: {e}")

# Example Usage
convert_jpg_to_png("24asia-logo.jpg", "app_logo.png")
