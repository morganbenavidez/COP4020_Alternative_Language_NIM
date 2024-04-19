# COP4020_Alternative_Language_NIM

# Alternative Language Project - NIM

Language and Version: I chose Nim version 1.6.0 for this project. Nim offers the performance of C with the readability of Python, ideal for efficient systems programming with an easy development process.

Why Nim?
I picked Nim for its excellent support for complex data processing tasks and its compatibility with C, C++ and JavaScript, which allows for flexible integration with various systems. Nim also provides clean syntax, helping simplify code for data manipulation.

Nim Features in Action
Object-Oriented Programming: Nim supports object-oriented principles. I used these to define a Cell type that encapsulates properties of cell phones.

File Handling: Using Nim's os and streams modules, I efficiently read and processed CSV files, handling large volumes of data seamlessly.

Control Structures: Nim's conditional statements, loops, and assignment statements were crucial for implementing the logic required for data analysis.

Functions and Exception Handling: Nim’s function definitions (proc) and exception handling mechanisms (try, except) allowed me to write robust, reusable code components and handle errors effectively during data transformations.

Libraries Used

tables: This library was invaluable for creating and managing hash tables, which I used for data aggregation tasks like calculating average weights and counting features.

strutils and strformat: Essential for string manipulation, these libraries helped me clean, split, and format strings effectively, facilitating CSV file parsing and output preparation.

unittest: This framework supported my unit testing efforts, ensuring each function worked as expected, crucial for maintaining reliable data transformations.

Project Outcomes and Analysis
Heaviest Phones by OEM: HP turned out to have the highest average weight for phone bodies, indicating a trend towards more robust phone designs.

Launch Discrepancies: Several models, such as Motorola's One Hyper and Xiaomi's Mi Mix Alpha, were announced one year and released the next, pointing to industry trends in delayed releases.

Feature Sensor Analysis: I discovered that 432 phones in our dataset featured only one sensor, indicating a segment of simpler, possibly more cost-effective phones.

Most Active Launch Years Post-1999: The year 2019 saw the most phone launches, highlighting a peak year in mobile technology development and market dynamics.

These insights showcase Nim's robust capabilities for data processing, making it a suitable choice for detailed analytical tasks in technology product analysis.
