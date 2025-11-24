#include <stdlib.h>
#include <math.h>

/* Mathematical Utilities */

#define ITER(index, count) for(size_t index = 0; index < count; index++)

double sum_array(double* array, size_t count) {
  double result = 0.0;
  ITER(i, count) {
    result += array[i];
  }
  return result;
}

double sum_x2(double* array, size_t count) {
  double result = 0.0;
  ITER(i, count) {
    result += pow(array[i], 2);
  }
  return result;
}

double sum_x3(double* array, size_t count) {
  double result = 0.0;
  ITER(i, count) {
    result += pow(array[i], 3);
  }
  return result;
}

double sum_x4(double* array, size_t count) {
  double result = 0.0;
  ITER(i, count) {
    result += pow(array[i], 4);
  }
  return result;
}

double sum_x2y(double* xs, double* ys, size_t count) {
  double result = 0.0;
  ITER(i, count) {
    result += pow(xs[i], 2)*ys[i];
  }
  return result;
}

double dot_product(double* xs, double* ys, size_t count) {
  double result = 0.0;
  ITER(i, count) {
    result += xs[i]*ys[i];
  }
  return result;
}

/* Statistics */

double correlation_coefficient(double* xs, double* ys, size_t count) {
  double sum_x = sum_array(xs, count);
  double sum_y = sum_array(ys, count);

  double numerator = (count*dot_product(xs, ys, count) - sum_x*sum_array(ys, count));
  double a = count*sum_x2(xs, count) - pow(sum_x, 2);
  double b = count*sum_x2(ys, count) - pow(sum_y, 2);

  return numerator/(sqrt(a)*sqrt(b));
}

/* Curve fitting */

typedef struct {
  double a;
  double b;
} linear_fit_t;

typedef struct {
  double a;
  double b;
  double c;
} parabolic_fit_t;

linear_fit_t cephem_linear_regression(double* xs, double* ys, size_t count) {
  double sum_x = sum_array(xs, count);
  double sum_y = sum_array(ys, count);
  double sum_xy = dot_product(xs, ys, count);

  /* Compute the denominator: count*Σx^2 - (Σx)^2 */
  double denominator = count*sum_x2(xs, count) - pow(sum_x, 2);

  /* Compute the numerator of a: count*Σxy - ΣxΣy */
  double num_a = count*sum_xy - sum_x*sum_y;

  /* Compute the numerator of b: Σy*Σx^2 - ΣxΣxy */
  double num_b = sum_y*sum_x2(xs, count) - sum_x*sum_xy;

  return (linear_fit_t){ .a = num_a/denominator, .b = num_b/denominator };
}

parabolic_fit_t quadratic_regression(double* xs, double* ys, size_t count) {
  double N = count;
  double P = sum_array(xs, count);
  double Q = sum_x2(xs, count);
  double R = sum_x3(xs, count);
  double S = sum_x4(xs, count);
  double T = sum_array(ys, count);
  double U = dot_product(xs, ys, count);
  double V = sum_x2y(xs, ys, count);
  double D = N*Q*S + 2*P*Q*R - pow(Q, 3) - pow(P, 2)*S - N*pow(R, 2);

  double a = (N*Q*V + P*R*T + P*Q*U - pow(Q, 2)*T - pow(P, 2)*V - N*R*U)/D;
  double b = (N*S*U + P*Q*V + Q*R*T - pow(Q, 2)*U - P*S*T - N*R*V)/D;
  double c = (Q*S*T + Q*R*U + P*R*V - pow(Q, 2)*V - P*S*U - pow(R, 2)*T)/D;

  return (parabolic_fit_t){ .a = a, .b = b, .c = c };
}

int main() {
  return 0;
}
