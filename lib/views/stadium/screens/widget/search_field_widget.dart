import 'package:sport/app/app_packges.dart';

class SearchFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final bool enabled;
  final VoidCallback? onTap;
  final String? initialValue;

  const SearchFieldWidget({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    required this.enabled,
    this.onTap,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    if (controller != null && initialValue != null) {
      controller!.text = initialValue!;
    }

    return BlocProvider(
      create: (context) => StadiumSearchCubit(),
      child: Material(
        elevation: 0, // Remove shadow
        child: GestureDetector(
          onTap: onTap,
          child: SizedBox(
            child: TextField(

              enabled: enabled,
              controller: controller,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              decoration: InputDecoration(
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10), // Adjust padding to reduce height
                hintText: "حدد المدينة",
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: GoogleFonts.cairo().fontFamily,
                  fontSize: Responsive.textSize(context, 10),
                ),
                prefixIcon: const Icon(Icons.search),
                alignLabelWithHint: true, // Align the hint text in the center
              ),
            ),
          ),
        ),
      ),
    );
  }
}