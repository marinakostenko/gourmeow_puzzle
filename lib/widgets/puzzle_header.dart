// import 'package:flutter/cupertino.dart';
//
// class PuzzleHeader extends StatelessWidget {
//   /// {@macro puzzle_header}
//   const PuzzleHeader({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 96,
//       child: ResponsiveLayoutBuilder(
//         small: (context, child) => Stack(
//           children: [
//             const Align(
//               child: PuzzleLogo(),
//             ),
//             Align(
//               alignment: Alignment.centerRight,
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 34),
//                 child: AudioControl(key: audioControlKey),
//               ),
//             ),
//           ],
//         ),
//         medium: (context, child) => Padding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 50,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: const [
//               PuzzleLogo(),
//               PuzzleMenu(),
//             ],
//           ),
//         ),
//         large: (context, child) => Padding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 50,
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: const [
//               PuzzleLogo(),
//               PuzzleMenu(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// /// {@template puzzle_logo}
// /// Displays the logo of the puzzle.
// /// {@endtemplate}
// @visibleForTesting
// class PuzzleLogo extends StatelessWidget {
//   /// {@macro puzzle_logo}
//   const PuzzleLogo({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//
//     return AppFlutterLogo(
//       key: puzzleLogoKey,
//       isColored: theme.isLogoColored,
//     );
//   }
// }