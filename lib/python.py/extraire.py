import cv2
import pytesseract

def extract_information(image_path, annotations):
    # Read the image
    image = cv2.imread(image_path)

    # Configure Tesseract OCR
    pytesseract.pytesseract.tesseract_cmd = r'C:/Program Files/Tesseract-OCR/tesseract.exe'

    # Loop through annotations and extract information
    extracted_info = {}
    for annotation in annotations:
        label = annotation["label"]
        coordinates = annotation["coordinates"]

        x, y, w, h = int(coordinates["x"]), int(coordinates["y"]), int(coordinates["width"]), int(coordinates["height"])
        region_of_interest = image[y:y+h, x:x+w]

  
        extracted_text = extract_text_from_region(region_of_interest)

        extracted_info[label] = extracted_text

    return extracted_info

def extract_text_from_region(region):
    extracted_text = pytesseract.image_to_string(region, config='--psm 6')  
    return extracted_text.strip()


json_data = [
    {
        "image": "idCard.jpg",
        "annotations": [
        {
          "label": "Nom",
          "coordinates": {
            "x": 266.5,
            "y": 153.5,
            "width": 99.0,
            "height": 31.0
          }
        },
        {
          "label": "Prenom",
          "coordinates": {
            "x": 282.5,
            "y": 210.5,
            "width": 135.0,
            "height": 29.0
          }
        },
        {
          "label": "MiddleName",
          "coordinates": {
            "x": 271.0,
            "y": 261.0,
            "width": 110.0,
            "height": 30.0
          }
        },
        {
          "label": "DateNaissance",
          "coordinates": {
            "x": 284.0,
            "y": 313.5,
            "width": 136.0,
            "height": 27.0
          }
        },
        {
          "label": "IssueDate",
          "coordinates": {
            "x": 439.0,
            "y": 314.0,
            "width": 134.0,
            "height": 30.0
          }
        },
        {
          "label": "Nationality",
          "coordinates": {
            "x": 249.0,
            "y": 366.5,
            "width": 64.0,
            "height": 27.0
          }
        },
        {
          "label": "Sex",
          "coordinates": {
            "x": 388.5,
            "y": 367.5,
            "width": 41.0,
            "height": 35.0
          }
        },
        {
          "label": "Height",
          "coordinates": {
            "x": 510.0,
            "y": 369.5,
            "width": 74.0,
            "height": 33.0
          }
        },
        {
          "label": "DateExpiration",
          "coordinates": {
            "x": 509.0,
            "y": 500.0,
            "width": 76.0,
            "height": 28.0
          }
        },
        {
          "label": "CIN",
          "coordinates": {
            "x": 697.5,
            "y": 500.0,
            "width": 173.0,
            "height": 28.0
          }
        }
      ]
    }
]

for entry in json_data:
    image_path = entry["image"]
    annotations = entry["annotations"]

    result = extract_information(image_path, annotations)

    # Display extracted information
    print(f"Extracted information for {image_path}:")
    for label, value in result.items():
        print(f"{label}: {value}")
    print("\n")
