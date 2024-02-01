class Either<Left, Right> {
  factory Either.right(Right value) {
    return Either._(null, value, false);
  }

  factory Either.left(Left failure) {
    return Either._(failure, null, true);
  }

  Either._(this._left, this._right, this.isLeft);
  final Left? _left;
  final Right? _right;
  final bool isLeft;

  T when<T>(
    T Function(Left) left,
    T Function(Right) right,
  ) {
    if (isLeft) {
      return left(_left as Left);
    } else {
      return right(_right as Right);
    }
  }
}
