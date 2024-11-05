# RecipeArchive
An iOS app built with SwiftUI that lets you explore food recipes from around the world.

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

I allocated approximately 7 hours to this project:
- **Planning and Design** (1 hours): Outlined the app architecture and decided on the technology stack.
- **Coding** (5 hours): Developed and refined the core functionality and UI.
- **Testing** (1 hours): Created unit tests, executed testing sessions, and resolved bugs.

## Trade-offs and Decisions

To balance time constraints and achieve a functioning app, I made the following trade-offs:
- **UI Complexity**: Opted for a straightforward and functional UI to ensure reliable app performance, postponing more complex UI features for future updates.
- **External Libraries**: Decided to avoid third-party libraries for networking and JSON decoding, using native tools instead to keep the code lightweight and maintainable.

## Weakest Part of the Project

- **UI Design**: While functional, the user interface is relatively simple. Given additional time, I would enhance the visual elements and interactivity to create a more engaging experience for users.

## External Code and Dependencies

- **Kingfisher**: Employed the Kingfisher library to handle asynchronous image downloading and caching. This choice enhances app performance and user experience by reducing load times and optimizing memory usage, especially for image-heavy content.

### Additional Information on Kingfisher Integration
- **Performance Optimization**: Kingfisher's caching system minimizes network requests, improving the app’s performance and responsiveness, particularly for users with limited data connectivity.
- **Custom Configurations**: Tuned cache duration and size in Kingfisher to balance performance and storage needs, ensuring optimal image freshness without excessive storage use.

## Additional Information

- **Concurrency Management**: Handling asynchronous data fetching and UI updates required careful concurrency management. Swift’s concurrency features helped maintain a smooth user experience but required additional debugging and adjustments to fully integrate.
- **Future Enhancements**: Potential future features include a more advanced caching mechanism for offline functionality, an improved User Interface and an extended recipe model to incorporate detailed nutritional information for each recipe.

