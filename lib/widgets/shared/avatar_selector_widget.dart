import 'package:flutter/material.dart';
class AvatarSelectorWidget extends StatefulWidget {
  final Map<String, dynamic> localizedStrings;
  final String initialDisplayName;
  final ValueChanged<String>? onAvatarSelected;
  final ValueChanged<String>? onDisplayNameChanged;
  const AvatarSelectorWidget({
    super.key,
    required this.localizedStrings,
    required this.initialDisplayName,
    this.onAvatarSelected,
    this.onDisplayNameChanged,
  });
  @override
  State<AvatarSelectorWidget> createState() => _AvatarSelectorWidgetState();
}
class _AvatarSelectorWidgetState extends State<AvatarSelectorWidget> {
  final List<String> avatarList = [
  'assets/images/pilots/pixelArt/Adolf Galland.png',
  'assets/images/pilots/pixelArt/Benjamin O. Davis Jr..png',
  'assets/images/pilots/pixelArt/Captain Radamés Gaxiola Andrad.png',
  'assets/images/pilots/pixelArt/Coronel Antonio Cárdenas Rodríguez.png',
  'assets/images/pilots/pixelArt/Eric Winkle Brown.png',
  'assets/images/pilots/pixelArt/Erich Hartmann.png',
  'assets/images/pilots/pixelArt/Francis Gabreski.png',
  'assets/images/pilots/pixelArt/Franco Lucchini.png',
  'assets/images/pilots/pixelArt/Giuseppe Cenni.png',
  'assets/images/pilots/pixelArt/Gregory Pappy Boyington.png',
  'assets/images/pilots/pixelArt/Gunther Rall.png',
  'assets/images/pilots/pixelArt/Hans-Joachim Marseille.png',
  'assets/images/pilots/pixelArt/Hans-Ulrich_Rudel.png',
  'assets/images/pilots/pixelArt/Hiroyoshi Nishizawa.png',
  'assets/images/pilots/pixelArt/Ivan Kozhedub.png',
  'assets/images/pilots/pixelArt/Lieutenant Miguel Moreno Arreola.png',
  'assets/images/pilots/pixelArt/Lieutenant Reynaldo Pérez Gallardo.png',
  'assets/images/pilots/pixelArt/Luigi Gorrini.png',
  'assets/images/pilots/pixelArt/Lydia Litvyak.png',
  'assets/images/pilots/pixelArt/Saburō Sakai.png',
  'assets/images/pilots/pixelArt/Satoshi Anabuki.png',
  'assets/images/pilots/pixelArt/Takeo Tanimizu.png',
  'assets/images/pilots/pixelArt/Teresio Martinoli.png',
  'assets/images/pilots/pixelArt/Tetsuzō Iwamoto.png',
];
  late String selectedAvatar;
  late TextEditingController _displayNameController;
  @override
  void initState() {
    super.initState();
    selectedAvatar = avatarList.first;
    _displayNameController = TextEditingController(text: widget.initialDisplayName);
  }
  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final title = widget.localizedStrings['profile']?['title'] ?? 'Profile Settings';
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(25),
        border: Border.all(color: Colors.purpleAccent),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          // 🖼️ Avatar Grid (scrollable and bounded)
          SizedBox(
            height: 300, // Adjust height as needed
            child: GridView.builder(
              itemCount: avatarList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final avatarPath = avatarList[index];
                final isSelected = avatarPath == selectedAvatar;
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedAvatar = avatarPath);
                    widget.onAvatarSelected?.call(avatarPath);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? Colors.purpleAccent : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      avatarPath,
                      width: 64,
                      height: 64,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          // 🧑 Display Name Input          
          const SizedBox(height: 8),
          //Text(note, style: const TextStyle(color: Colors.purpleAccent, fontSize: 12)),
        ],
      ),
    );
  }
}