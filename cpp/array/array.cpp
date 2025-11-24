#include <cstddef>
#include <algorithm>
#include <stdexcept>
#include <cassert>
#include <cstring>
#include <iostream>
#include <vector>
#include <functional>

/* Chunks */

template <typename T>
struct Chunk {
  T* data;
  std::size_t size;
};

template <typename T>
void shift_left(T* data, std::size_t size, std::size_t shift) {
  T* dest = data - shift;
  T* orig = data;
  std::size_t count = size * sizeof(T);
  std::memmove(dest, orig, count);
}

template <typename T>
void shift_right(T* data, std::size_t size, std::size_t shift) {
  T* dest = data + shift;
  T* orig = data;
  std::size_t count = size * sizeof(T);
  std::memmove(dest, orig, count);
}

/* Types */

static constexpr std::size_t MINIMUM_CAPACITY = 16;

template <typename T>
struct Array {
  T& operator[](std::size_t index);
  const T& operator[](std::size_t index) const;

  T* data;
  std::size_t size;
  std::size_t capacity;
};

/* Create */

template <typename T>
Array<T> allocate_array_elem(std::size_t size, T value) {
  Array<T> arr;
  arr.data = new T[size];
  arr.size = size;
  arr.capacity = std::max(size, MINIMUM_CAPACITY);
  std::fill(arr.data, arr.data + size, value);
  return arr;
}

template <typename T>
Array<T> allocate_empty_array() {
  Array<T> arr;
  arr.data = new T[MINIMUM_CAPACITY];
  arr.size = 0;
  arr.capacity = MINIMUM_CAPACITY;
  return arr;
}

/* Retrieve */

template <typename T>
std::size_t length(Array<T> arr) {
  assert(arr.data != nullptr);
  return arr.size;
}

template <typename T>
T& Array<T>::operator[](std::size_t index) {
  assert(data != nullptr);
  if (index >= size) {
    throw std::out_of_range("index out of range");
  }
  return data[index];
}

template <typename T>
const T& Array<T>::operator[](std::size_t index) const {
  assert(data != nullptr);
  if (index >= size) {
    throw std::out_of_range("index out of range");
  }
  return data[index];
}

/* Update */

template <typename T>
void bump(Array<T>& arr) {
  assert(arr.data != nullptr);
  std::size_t new_capacity = arr.capacity * 2;
  T* new_data = new T[new_capacity];
  std::memcpy(new_data, arr.data, arr.size * sizeof(T));
  delete[] arr.data;
  arr.data = new_data;
  arr.capacity = new_capacity;
}

template <typename T>
void insert(Array<T>& arr, std::size_t index, T value) {
  assert(arr.data != nullptr);
  if (index > arr.size) {
    throw std::out_of_range("index out of range");
  }
  if (arr.size == arr.capacity) {
    bump(arr);
  }
  if (arr.size != 0) {
    T* chunk_start = arr.data + index;
    std::size_t chunk_length = arr.size - index;
    shift_right(chunk_start, chunk_length, 1);
  }
  arr.data[index] = value;
  ++arr.size;
}

template <typename T>
void insert_front(Array<T>& arr, T value) {
  insert(arr, 0, value);
}

template <typename T>
void insert_back(Array<T>& arr, T value) {
  if (arr.size == 0) {
    insert(arr, 0, value);
  } else {
    insert(arr, arr.size, value);
  }
}

template <typename T>
void reverse(Array<T>& arr) {
  assert(arr.data != nullptr);
  for (std::size_t i = 0; i < arr.size / 2; ++i) {
    std::swap(arr[i], arr[arr.size - i - 1]);
  }
}

/* Delete */

template <typename T>
void destroy_array(Array<T>& arr) {
  assert(arr.data != nullptr);
  delete[] arr.data;
  arr.data = nullptr;
  arr.size = 0;
  arr.capacity = 0;
}

template <typename T>
T remove(Array<T>& arr, std::size_t index) {
  assert(arr.data != nullptr);
  if (arr.size == 0) {
    throw std::out_of_range("Array is empty");
  }
  if (index >= arr.size) {
    throw std::out_of_range("index out of range");
  }
  T value = arr.data[index];
  // Move the elements to the left, unless this is the last index of the array.
  if (index < (arr.size-1)) {
    T* chunk_start = arr.data + index + 1;
    std::size_t chunk_length = arr.size - 1 - index;
    shift_left(chunk_start, chunk_length, 1);
  }
  --arr.size;
  return value;
}

template <typename T>
T remove_first(Array<T>& arr) {
  return remove(arr, 0);
}

template <typename T>
T remove_last(Array<T>& arr) {
  return remove(arr, arr.size - 1);
}

template <typename T>
bool remove_if(Array<T>& arr, std::function<bool(const T&)> predicate) {
  for (std::size_t i = 0; i < arr.size; ++i) {
    if (predicate(arr[i])) {
      remove(arr, i);
      return true;
    }
  }
  return false;
}

/* Tests */

void test_empty() {
  Array<int> arr = allocate_array_elem(3, 10);
  assert(length(arr) == 3);
  assert(arr[0] == 10);
  assert(arr[1] == 10);
  assert(arr[2] == 10);
  arr[0] = 20;
  assert(arr[0] == 20);
  destroy_array(arr);
}

void test_insert() {
  Array<int> e = allocate_empty_array<int>();
  assert(length(e) == 0);
  insert_back(e, 30);
  assert(length(e) == 1);
  assert(e[0] == 30);
  insert(e, 0, 20);
  assert(length(e) == 2);
  assert(e[0] == 20);
  assert(e[1] == 30);
  insert(e, 0, 10);
  assert(length(e) == 3);
  assert(e[0] == 10);
  assert(e[1] == 20);
  assert(e[2] == 30);
}

void test_insert2() {
  // []
  Array<int> arr = allocate_empty_array<int>();
  assert(length(arr) == 0);
  // [1]
  insert_back(arr, 1);
  assert(length(arr) == 1);
  assert(arr[0] == 1);
  // [1, 2]
  insert(arr, 1, 2);
  assert(length(arr) == 2);
  assert(arr[0] == 1);
  assert(arr[1] == 2);
  // [1, 3, 2]
  insert(arr, 1, 3);
  assert(length(arr) == 3);
  assert(arr[0] == 1);
  assert(arr[1] == 3);
  assert(arr[2] == 2);
  // Bye
  destroy_array(arr);
}

void test_insert_front_back() {
  // []
  Array<int> arr = allocate_empty_array<int>();
  // [1]
  insert_back(arr, 1);
  assert(length(arr) == 1);
  assert(arr[0] == 1);
  // [1, 2]
  insert_back(arr, 2);
  assert(length(arr) == 2);
  assert(arr[0] == 1);
  assert(arr[1] == 2);
  // Bye
  destroy_array(arr);
}

void test_remove() {
  // [1,2,3]
  Array<int> arr = allocate_empty_array<int>();
  insert_back(arr, 1);
  insert_back(arr, 2);
  insert_back(arr, 3);
  assert(length(arr) == 3);
  assert(arr[0] == 1);
  assert(arr[1] == 2);
  assert(arr[2] == 3);
  // [2,3]
  int first = remove(arr, 0);
  assert(length(arr) == 2);
  assert(first == 1);
  assert(arr[0] == 2);
  assert(arr[1] == 3);
  // [2]
  int third = remove(arr, 1);
  assert(length(arr) == 1);
  assert(third == 3);
  assert(arr[0] == 2);
  // []
  int second = remove(arr, 0);
  assert(length(arr) == 0);
  assert(second == 2);
  destroy_array(arr);
}

void test_remove_first() {
  // [1,2,3]
  Array<int> arr = allocate_empty_array<int>();
  insert_back(arr, 1);
  insert_back(arr, 2);
  insert_back(arr, 3);
  assert(length(arr) == 3);
  // [2,3]
  assert(remove_first(arr) == 1);
  assert(length(arr) == 2);
  assert(arr[0] == 2);
  assert(arr[1] == 3);
  // [3]
  assert(remove_first(arr) == 2);
  assert(length(arr) == 1);
  assert(arr[0] == 3);
  // [1]
  assert(remove_first(arr) == 3);
  assert(length(arr) == 0);
}

void test_remove_last() {
  // [1,2,3]
  Array<int> arr = allocate_empty_array<int>();
  insert_back(arr, 1);
  insert_back(arr, 2);
  insert_back(arr, 3);
  assert(length(arr) == 3);
  // [1,2]
  assert(remove_last(arr) == 3);
  assert(length(arr) == 2);
  assert(arr[0] == 1);
  assert(arr[1] == 2);
  // [1]
  assert(remove_last(arr) == 2);
  assert(length(arr) == 1);
  assert(arr[0] == 1);
  // []
  assert(remove_last(arr) == 1);
  assert(length(arr) == 0);
}

void test_reverse() {
  Array<int> arr = allocate_empty_array<int>();
  insert_back(arr, 1);
  insert_back(arr, 2);
  insert_back(arr, 3);
  assert(length(arr) == 3);
  assert(arr[0] == 1);
  assert(arr[1] == 2);
  assert(arr[2] == 3);
  reverse(arr);
  assert(length(arr) == 3);
  assert(arr[0] == 3);
  assert(arr[1] == 2);
  assert(arr[2] == 1);
}

void test_remove_if() {
  // [1, 2, 3, 4, 5]
  Array<int> arr = allocate_empty_array<int>();
  insert_back(arr, 1);
  insert_back(arr, 2);
  insert_back(arr, 3);
  insert_back(arr, 4);
  insert_back(arr, 5);
  assert(length(arr) == 5);

  // Remove elements equal to 3
  // [1, 2, 4, 5]
  std::function<bool(const int&)> equals3 = [](const int& elem) { return elem == 3; };
  remove_if(arr, equals3);
  assert(length(arr) == 4);
  assert(arr[0] == 1);
  assert(arr[1] == 2);
  assert(arr[2] == 4);
  assert(arr[3] == 5);

  // Remove elements less than 4
  // [2, 4, 5]
  std::function<bool(const int&)> lessthan4 = [](const int& elem) { return (elem < 4); };
  remove_if(arr, lessthan4);
  assert(length(arr) == 3);
  assert(arr[0] == 2);
  assert(arr[1] == 4);
  assert(arr[2] == 5);

  // Try to remove element from empty array
  Array<int> empty_arr = allocate_empty_array<int>();
  assert(length(empty_arr) == 0);
  remove_if(empty_arr, equals3);
  assert(length(empty_arr) == 0);
}

int main () {
  test_insert();
  test_insert2();
  test_insert_front_back();
  test_remove();
  test_remove_first();
  test_remove_last();
  test_reverse();
  test_remove_if();
  return 0;
}
