#include <gtest/gtest.h>
#include "print.h"

TEST(PrintTest, HelloReturnsCorrectString) {
    EXPECT_EQ(print::hello(), "Hello, future!");
}
