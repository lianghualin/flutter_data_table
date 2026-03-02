import 'package:flutter_test/flutter_test.dart';
import 'package:advanced_data_table/advanced_data_table.dart';

void main() {
  group('DataTablePlusTheme', () {
    test('defaultTheme has correct default values', () {
      const theme = DataTablePlusTheme.defaultTheme;
      expect(theme.borderRadius, 12.0);
      expect(theme.borderRadiusSmall, 8.0);
    });

    test('copyWith creates a new theme with updated values', () {
      const theme = DataTablePlusTheme.defaultTheme;
      final newTheme = theme.copyWith(borderRadius: 16.0);
      expect(newTheme.borderRadius, 16.0);
      expect(newTheme.borderRadiusSmall, 8.0);
    });
  });
}
