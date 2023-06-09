import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tomato_leave_virus_mobile/models/plant.dart';

/// A language observer.
///
/// return true if language state is hause, otherwise it returns false
/// Initial state of the provider is false ie English
final isHausa =
    StateNotifierProvider<IsHausaProvider, bool>((ref) => IsHausaProvider());

class IsHausaProvider extends StateNotifier<bool> {
  IsHausaProvider() : super(false);

  /// responsible for changing the language state from hause to english
  void changeLanguage(Language language) {
    state = language.index == 0 ? false : true;
  }
}
