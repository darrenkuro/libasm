#include <assert.h>
#include <errno.h> // errno
#include <fcntl.h>
#include <stdio.h>  // ssize_t, size_t, printf, puts
#include <stdlib.h> // free
#include <string.h> // strerrno
#include <unistd.h>

#define SEP() puts("--------------------------------------------------")
#define TEST_OK(desc)                                                                              \
    do {                                                                                           \
        printf("%-30s✅\n", desc);                                                                 \
        pass++;                                                                                    \
    } while (0)
#define TEST_FAIL(desc, fmt, ...)                                                                  \
    do {                                                                                           \
        printf("%-30s❌ (" fmt ")\n", desc, ##__VA_ARGS__);                                        \
    } while (0)

// Functions
ssize_t ft_read(int fd, void *buf, size_t count);
ssize_t ft_write(int fd, const void *buf, size_t count);
int ft_strcmp(const char *s1, const char *s2);
size_t ft_strlen(const char *s);
char *ft_strcpy(char *dest, const char *src);
char *ft_strdup(const char *s);

void test_strlen(void) {
    SEP();
    puts("Testing ft_strlen");
    struct {
        const char *s;
        const char *desc;
    } tests[] = {
        {"", "empty string"},
        {"a", "single character"},
        {"hello", "short string"},
        {"hello world", "string with space"},
        {"ab\0cd", "stops at first null byte"},
        {"0123456789abcdef", "hex digits"},
        {"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", "repeated chars"},
        {"\xff\xfe\xfd", "non-ASCII bytes"},
    };

    size_t count = sizeof(tests) / sizeof(tests[0]);
    size_t pass = 0;

    for (size_t i = 0; i < count; i++) {
        size_t exp = strlen(tests[i].s);
        size_t got = ft_strlen(tests[i].s);

        if (got == exp)
            TEST_OK(tests[i].desc);
        else
            TEST_FAIL(tests[i].desc, "expected %zu, got %zu", exp, got);
    }

    printf("%-30s%s  %zu/%zu\n", "ft_strlen:", pass == count ? "✅" : "⚠️", pass, count);
}

void test_strcmp(void) {
    SEP();
    puts("Testing ft_strcmp");

    struct {
        const char *a;
        const char *b;
        const char *desc;
    } tests[] = {
        {"", "", "empty strings"},
        {"a", "a", "equal single chars"},
        {"abc", "abc", "equal strings"},
        {"abc", "abcd", "shorter vs longer"},
        {"abcd", "abc", "longer vs shorter"},
        {"abc", "abC", "case difference >"},
        {"abC", "abc", "case difference <"},
    };

    size_t count = sizeof(tests) / sizeof(tests[0]);
    size_t pass = 0;

    for (size_t i = 0; i < count; i++) {
        int exp = strcmp(tests[i].a, tests[i].b);
        int got = ft_strcmp(tests[i].a, tests[i].b);

        if ((got == 0 && exp == 0) || (got < 0 && exp < 0) || (got > 0 && exp > 0))
            TEST_OK(tests[i].desc);
        else
            TEST_FAIL(tests[i].desc, "expected sign %d, got %d", exp, got);
    }

    printf("%-30s%s  %zu/%zu\n", "ft_strcmp:", pass == count ? "✅" : "⚠️", pass, count);
}

void test_strcpy(void) {
    SEP();
    puts("Testing ft_strcpy");

    struct {
        const char *src;
        const char *desc;
    } tests[] = {
        {"", "empty string"},
        {"abc", "short string"},
        {"hello world", "string with spaces"},
    };

    char buf[64];
    size_t count = sizeof(tests) / sizeof(tests[0]);
    size_t pass = 0;

    for (size_t i = 0; i < count; i++) {
        char *ret = ft_strcpy(buf, tests[i].src);

        if (ret == buf && strcmp(buf, tests[i].src) == 0)
            TEST_OK(tests[i].desc);
        else
            TEST_FAIL(tests[i].desc, "copy failed");
    }

    printf("%-30s%s  %zu/%zu\n", "ft_strcpy:", pass == count ? "✅" : "⚠️", pass, count);
}

void test_strdup(void) {
    SEP();
    puts("Testing ft_strdup");

    const char *tests[] = {
        "",
        "abc",
        "hello world",
    };

    size_t count = sizeof(tests) / sizeof(tests[0]);
    size_t pass = 0;

    for (size_t i = 0; i < count; i++) {
        char *s = ft_strdup(tests[i]);

        if (s && strcmp(s, tests[i]) == 0) {
            TEST_OK(tests[i]);
            free(s);
        } else {
            TEST_FAIL(tests[i], "dup failed");
            free(s);
        }
    }

    printf("%-30s%s  %zu/%zu\n", "ft_strdup:", pass == count ? "✅" : "⚠️", pass, count);
}

void test_write(void) {
    SEP();
    puts("Testing ft_write");

    size_t pass = 0;
    size_t count = 2;

    fflush(stdout);
    errno = 0;
    ssize_t r = ft_write(1, "hello\n", 6);
    if (r == 6)
        TEST_OK("valid fd");
    else
        TEST_FAIL("valid fd", "returned %zd", r);

    errno = 0;
    r = ft_write(-1, "x", 1);
    if (r == -1 && errno == EBADF)
        TEST_OK("invalid fd");
    else
        TEST_FAIL("invalid fd", "r=%zd errno=%d", r, errno);

    printf("%-30s%s  %zu/%zu\n", "ft_write:", pass == count ? "✅" : "⚠️", pass, count);
}

void test_read(void) {
    SEP();
    puts("Testing ft_read");

    size_t pass = 0;
    size_t count = 2;
    char buf[16];

    int fd = open("test/input.txt", O_RDONLY);
    if (fd >= 0) {
        ssize_t r = ft_read(fd, buf, sizeof(buf) - 1);
        if (r > 0)
            TEST_OK("valid fd");
        else
            TEST_FAIL("valid fd", "r=%zd", r);
        close(fd);
    } else
        TEST_FAIL("valid fd", "open failed");

    errno = 0;
    ssize_t r = ft_read(-1, buf, 1);
    if (r == -1 && errno == EBADF)
        TEST_OK("invalid fd");
    else
        TEST_FAIL("invalid fd", "r=%zd errno=%d", r, errno);

    printf("%-30s%s  %zu/%zu\n", "ft_read:", pass == count ? "✅" : "⚠️", pass, count);
}

int main() {
    test_strlen();
    test_strcmp();
    test_strcpy();
    test_strdup();
    test_write();
    test_read();
    return 0;
}
