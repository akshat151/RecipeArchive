# RecipeArchive
An iOS app built with SwiftUI that lets you explore food recipes from around the world.

## Requirements

- **Minimum iOS Version**: 16.0
- **Xcode**: Version 16 or higher

### Features

- **Recipe List with Pull-to-Refresh**: Allows users to pull down on the recipe list at any time to quickly refresh and load the latest recipes.
  
- **Cuisine Type Filter**: A filter button in the top-right corner lets users filter recipes by cuisine type. By default, All cuisines are displayed.

- **Recipe Detail Pop-Up**: Tapping on a recipe opens a pop-up with options to navigate to the recipe's URL or watch it's YouTube video outside of the App, enhancing interactivity.

- **Single-Screen UI**: The app features a streamlined single-screen layout displaying the recipe list and filter button, promoting easy navigation and focus on recipe content.

## Steps to Run the App

1. **Clone the repository**: Clone this repository using `git clone https://github.com/akshat151/RecipeArchive.git`.
2. **Open the project**: Launch Xcode, and open the `.xcodeproj` file.
3. **Install dependencies**: Install Kingfisher via the Swift Package Manager in Xcode. In Xcode: File > Add Packages, Enter: https://github.com/onevcat/Kingfisher.git and Select version 8.1.0.
4. **Set up the environment**: Ensure any required environment variables or API keys are configured.
5. **Build the project**: Select a target device or simulator in Xcode, then build the project.
6. **Run the application**: Launch the app on a selected simulator or device from within Xcode.

## Focus Areas

### Key Areas of Focus
- **Data Handling**: Prioritized accurate parsing and handling of data from remote sources, as reliable data processing is essential for displaying recipes correctly.
- **Error Handling**: Ensured that the app could gracefully manage issues such as network interruptions and data corruption, maintaining a user-friendly experience with informative error messages.
- **User Interface and Experience**: Focused on creating a responsive and intuitive user interface, given the visual and interactive nature of a recipe app.

### Enhanced Focus with Kingfisher Integration
- **User Experience**: Integrated Kingfisher to load images asynchronously, ensuring quick and smooth loading of recipe images. This optimizes user experience, as images are often the most engaging element of recipes.
- **Reliability**: Chose Kingfisher for its robust caching and asynchronous handling, which enhances app reliability and responsiveness.

## Time Spent

I allocated approximately 5 hours to this project:
- **Planning and Design** (0.5 hours): Outlined the app architecture and decided on the technology stack.
- **Coding** (4 hours): Developed and refined the core functionality and UI.
- **Testing** (0.5 hours): Created unit tests, executed testing sessions, and resolved bugs.

## Trade-offs and Decisions

To balance functionality, performance, and maintainability within the given timeline, I made the following trade-offs:

- **UI Complexity**: I prioritized a straightforward, functional UI to ensure reliable performance, deferring more complex, visually rich elements to potential future updates.
- **Image Caching with Kingfisher**: Rather than implementing a custom image downloading and caching solution, I chose to use Kingfisher. This decision was based on the library’s robust performance, streamlined API, and efficient handling of asynchronous image loading and caching. Kingfisher helped reduce development time and improve app responsiveness by handling network requests and caching seamlessly, which was essential given the image-centric nature of a recipe app.
- **External Libraries for Networking and JSON Parsing**: Opted to stick with native libraries for networking and JSON decoding (URLSession and Codable) rather than third-party options, as these tools provided the necessary functionality without adding extra dependencies, simplifying maintenance and reducing potential for bugs.

## Weakest Part of the Project

- **UI Design**: While functional, the user interface is relatively simple. Given additional time, I would enhance the visual elements and interactivity to create a more engaging experience for users.

## External Code and Dependencies

- **Kingfisher**: Employed the Kingfisher library to handle asynchronous image downloading and caching. This choice enhances app performance and user experience by reducing load times and optimizing memory usage, especially for image-heavy content.

### Additional Information on Kingfisher Integration
- **Performance Optimization**: Kingfisher's caching system minimizes network requests, improving the app’s performance and responsiveness, particularly for users with limited data connectivity.
- **Custom Configurations**: Tuned cache duration and size in Kingfisher to balance performance and storage needs, ensuring optimal image freshness without excessive storage use.

## Additional Information

- **Concurrency Management**: Handling asynchronous data fetching and UI updates required careful concurrency management. Swift’s concurrency features helped maintain a smooth user experience but required additional debugging and adjustments to fully integrate.
- **Future Enhancements**: Potential future features include a more advanced caching mechanism for offline functionality, an improved User Interface, better Test Coverage with more focus on UI Tests as well as integration tests and an extended recipe model to incorporate detailed nutritional information for each recipe.

