import 'package:flutter/material.dart';
import 'package:resize/resize.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'How to Type Math Questions on Mobile',
              style: TextStyle(
                fontSize: 20.0.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0.h),
            const Text(
              'Typing mathematical questions on a mobile device can be a bit challenging due to the absence of some symbols on the keyboard. However, you can use substitute symbols to represent common math operators:',
            ),
            SizedBox(height: 16.0.h),
            const Text(
                'You can use the maths keyboard inside the chat screen to type your math questions. if the desired symbol is not available, you can use the following substitute symbols:\n\n'
                '- Use "+" for addition (e.g., 2 + 3)\n'
                '- Use "-" for subtraction (e.g., 5 - 2)\n'
                '- Use "*" for multiplication (e.g., 4 * 6)\n'
                '- Use "/" for division (e.g., 10 / 2)\n'
                '- Use "^" for exponentiation (e.g., 2^3 for 2 raised to the power of 3)\n'
                '- Use "sqrt()" for square root (e.g., sqrt(25) for the square root of 25)\n'
                '- You can also use the following symbols for trigonometric functions:\n'
                '- Use "sin()" for sine (e.g., sin(30) for the sine of 30 degrees)\n'
                '- Use "cos()" for cosine (e.g., cos(60) for the cosine of 60 degrees)\n'
                '- Use "tan()" for tangent (e.g., tan(45) for the tangent of 45 degrees)\n'
                '- Use "cot()" for cotangent (e.g., cot(45) for the cotangent of 45 degrees)\n'
                '- Use "sec()" for secant (e.g., sec(60) for the secant of 60 degrees)\n'
                '- Use "csc()" for cosecant (e.g., csc(30) for the cosecant of 30 degrees)\n'
                '- Use "asin()" for arcsine (e.g., asin(0.5) for the arcsine of 0.5)\n'
                '- Use "acos()" for arccosine (e.g., acos(0.5) for the arccosine of 0.5)\n'
                '- Use "atan()" for arctangent (e.g., atan(1) for the arctangent of 1)\n'
                '- Use "acot()" for arccotangent (e.g., acot(1) for the arccotangent of 1)\n'
                '- Use "asec()" for arcsecant (e.g., asec(2) for the arcsecant of 2)\n'
                '- Use "acsc()" for arccosecant (e.g., acsc(2) for the arccosecant of 2)\n'
                '- Use "ln()" for natural logarithm (e.g., ln(2) for the natural logarithm of 2)\n'
                '- Use "log()" for logarithm (e.g., log(10) for the logarithm of 10)\n'
                '- Use "log(x, b)" for logarithm with base b (e.g., log(10, 2) for the logarithm of 10 with base 2)\n'
                '- Use "abs()" for absolute value (e.g., abs(-5) for the absolute value of -5)\n'
                '- Use "ceil()" for ceiling (e.g., ceil(2.5) for the ceiling of 2.5)\n'
                '- Use "floor()" for floor (e.g., floor(2.5) for the floor of 2.5)\n'
                '- Use "round()" for rounding (e.g., round(2.5) for rounding 2.5)\n'
                '- Use "min()" for minimum (e.g., min(2, 3) for the minimum of 2 and 3)\n'
                '- Use "max()" for maximum (e.g., max(2, 3) for the maximum of 2 and 3)\n'
                '- Use "avg()" for average (e.g., avg(2, 3) for the average of 2 and 3)\n'
                '- Use "sum()" for summation (e.g., sum(2, 3) for the summation of 2 and 3)\n'
                '- Use "prod()" for product (e.g., prod(2, 3) for the product of 2 and 3)\n'
                '- Use "!" for factorial (e.g., 5! for the factorial of 5)\n'
                '- Use "mod()" for modulo (e.g., mod(5, 2) for the modulo of 5 and 2)\n'
                '- Use "gcd()" for greatest common divisor (e.g., gcd(4, 6) for the greatest common divisor of 4 and 6)\n'
                '- Use "lcm()" for least common multiple (e.g., lcm(4, 6) for the least common multiple of 4 and 6)\n'
                '- Use "pi" for pi (e.g., pi for the value of pi)\n'
                '- Use "e" for Euler\'s number (e.g., e for the value of Euler\'s number)\n'
                '- Use "inf" for infinity (e.g., inf for the value of infinity)\n'
                '- Use "deg" for degrees (e.g., 90deg for 90 degrees)\n'
                '- Use "rad" for radians (e.g., 1rad for 1 radian)\n\n'),
            SizedBox(height: 16.0.h),
            const Text(
              'For more complex expressions, you can use parentheses to group terms and clarify the order of operations. For example:\n'
              '- (2 + 3) * 4 represents adding 2 and 3 first, then multiplying the result by 4.\n'
              '- 2 / (4 - 1) represents subtracting 1 from 4 first, then dividing 2 by the result.',
            ),
            SizedBox(height: 16.0.h),
            const Text(
              'Feel free to experiment with these substitute symbols to type your math questions accurately and efficiently on your mobile device!',
            ),
          ],
        ),
      ),
    );
  }
}
