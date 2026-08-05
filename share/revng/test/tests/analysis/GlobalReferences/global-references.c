//
// This file is distributed under the MIT License. See LICENSE.md for details.
//

#include <stdint.h>

// Two globals, so that the functions below reach into a data segment. The
// decompiler renders those accesses relative to the segment, which is what
// both the `emit-c` address annotations and the global references recorded in
// the cross relations are about.
uint64_t first_global = 0x1122334455667788;
uint64_t second_global = 0x99aabbccddeeff00;

uint64_t consume(uint64_t first, uint64_t second);

// Reads both globals.
uint64_t reads_globals(void) {
  return consume(first_global, second_global);
}

// Writes both globals, so that a reference is recorded no matter the direction
// the data travels in.
uint64_t writes_globals(uint64_t value) {
  first_global = value;
  second_global = value + 1;
  return 0;
}

// Touches no global at all, as the counter-example: nothing must be annotated
// or recorded for it.
uint64_t touches_nothing(uint64_t first, uint64_t second) {
  return first * 3 + second * 5;
}

uint64_t consume(uint64_t first, uint64_t second) {
  return first ^ second;
}

int main(int argc, char **argv) {
  return (int) (reads_globals() + writes_globals(argc)
                + touches_nothing(argc, argc + 1));
}
