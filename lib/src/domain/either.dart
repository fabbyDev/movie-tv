class Either<Left, Right> {
  final Left? _left;
  final Right? _right;
  final bool _isLeft;

  Either._(this._left, this._right, this._isLeft);

  factory Either.left(Left failure) {
    return Either._(failure, null, true);
  }

  factory Either.right(Right value) {
    return Either._(null, value, false);
  }

  T when<T>(
    T Function(Left) left,
    T Function(Right) right,
  ) {
    return (_isLeft) ? left(_left as Left) : right(_right as Right);
  }
}
