class UnboardingContent {
  final String image; // Store the image path as a string
  final String title;
  final String description;

  // Constructor with null safety (using required for non-nullable fields)
  UnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<UnboardingContent> contents = [
  UnboardingContent(
    title: 'Welcome to FOODO',
    image: 'assets/FOODOicon.png', // Path to the asset
    description:
        "Welcome to FOODO! Join us in creating a world with less waste and no hunger. \n"
        "Start your journey today! ",
  ),
  UnboardingContent(
    title: 'No More Food Waste',
    image: 'assets/waste.png',
    description:
        "Every bite counts! With FOODO, your leftover meals can bring smiles and nourishment to those in need. "
        "Let’s turn food waste into opportunities to make a difference.",
  ),
  UnboardingContent(
    title: 'Help Feed the Hungry',
    image: 'assets/man1.png',
    description:
        "Be a hero in someone's life! Share your extra food with hungry people in your community. "
        "FOODO connects kindness with need, making sharing food simple and impactful.",
  ),
];
