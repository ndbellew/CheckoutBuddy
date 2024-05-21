
# Checkout Buddy

    All in one application for helping the average shopper. 


# Grocery Calculator

Grocery Calculator is a simple Flutter application designed to help you keep track of your grocery spending. It works similarly to a calculator but supports addition and multiplication operations. The app maintains a history of your calculations and allows you to edit them as needed.

## Features

- Basic arithmetic operations: addition (`+`) and multiplication (`x`).
- Keeps track of all inputs and allows removal of selected inputs.
- Maintains a history of all equations.
- Allows editing of the history and updates the total accordingly.
- Simple and intuitive user interface.

## Getting Started

### Prerequisites

To run this project, you will need to have Flutter installed on your machine. You can follow the installation guide on the [official Flutter website](https://flutter.dev/docs/get-started/install).

### Installing

Clone the repository to your local machine:

```sh
git clone https://github.com/yourusername/grocery_calculator.git
cd grocery_calculator
```

### Running the App

To run the app on an emulator or a connected device, use the following command:

```sh
flutter run
```

Select the target device when prompted.

## Usage

### Number Pad

- **1, 2, 3, 4, 5, 6, 7, 8, 9, 0, .99, .**: Standard number and decimal input.
- **<**: Backspace to delete the last entered digit.

### Operation Buttons

- **+**: Adds the current input to the total.
- **x**: Multiplies the current input with the next entered number.
- **=**: Computes the final total of the current equation.

### History

- Tap on the history icon in the top right corner to view the history of all equations.
- Edit any equation directly in the history, and the total will update accordingly.

## Code Overview

### Main Files

- `main.dart`: The entry point of the application.
- `calculator_page.dart`: Contains the main calculator logic and UI.
- `history_page.dart`: Handles the history display and editing functionality.

### Key Functions

- `numPressed(String num)`: Handles number button presses.
- `addPressed()`: Handles the addition operation.
- `multiplyPressed()`: Handles the multiplication operation.
- `equalsPressed()`: Computes the final result.
- `backspacePressed()`: Deletes the last entered digit.
- `viewHistory()`: Navigates to the history page.

## Contributing

If you would like to contribute to this project, please fork the repository and submit a pull request with your changes. Contributions are welcome!

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Flutter](https://flutter.dev/) - The framework used to build this app.
- [Dart](https://dart.dev/) - The programming language used.
