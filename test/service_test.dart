import 'package:flutter_test/flutter_test.dart';
import 'package:scandium/product/network/product_network_manager.dart';
import 'package:scandium/product/repositories/user/user_repository.dart';

void main() {
  late UserRepository _userRepository;
  setUp(() {
    _userRepository = UserRepository(ProductNetworkManager());
  });
  test('Authentication', () async {
    final response = await _userRepository.authenticate(
        username: 'string1', password: 'String1');
    expect(response?.value, isNot(equals(null)));
  });
}
