#include <assert.h>
#include <errno.h> // errno
#include <fcntl.h>
#include <stdio.h>  // ssize_t, size_t, printf
#include <stdlib.h> // free
#include <string.h> // strerrno
#include <unistd.h>

#define SEP() puts("--------------------------------------------------")

// Functions
ssize_t ft_read(int fd, void *buf, size_t count);
ssize_t ft_write(int fd, void const *buf, size_t count);
int ft_strcmp(char const *_Nonnull s1, char const *_Nonnull s2);
size_t ft_strlen(char const *_Nonnull s);
char *ft_strcpy(char *_Nonnull dest, char const *_Nonnull src);
char *ft_strdup(char const *_Nonnull s);

void test_strlen(void) {
    SEP();
    puts("ft_strlen");

    assert(ft_strlen("") == strlen(""));
    assert(ft_strlen("a") == strlen("a"));
    assert(ft_strlen("abc") == strlen("abc"));
    assert(ft_strlen("hello world") == strlen("hello world"));

    // Embedded NUL
    assert(ft_strlen("ab\0cd") == 2);

    puts("ft_strlen OK");
}

void test_strcmp(void) {
    SEP();
    puts("ft_strcmp");

    assert(ft_strcmp("", "") == 0);
    assert(ft_strcmp("a", "a") == 0);
    assert(ft_strcmp("abc", "abc") == 0);

    assert(ft_strcmp("abc", "abcd") < 0);
    assert(ft_strcmp("abcd", "abc") > 0);

    assert(ft_strcmp("abc", "abC") > 0);
    assert(ft_strcmp("abC", "abc") < 0);

    // Signed-char edge cases
    char s1[] = {(char)0xFF, 0};
    char s2[] = {0, 0};

    assert((ft_strcmp(s1, s2) > 0) == (strcmp(s1, s2) > 0));

    puts("ft_strcmp OK");
}

void test_strcpy(void) {
    SEP();
    puts("ft_strcpy");

    char buf[64];

    assert(ft_strcpy(buf, "") == buf);
    assert(strcmp(buf, "") == 0);

    assert(ft_strcpy(buf, "abc") == buf);
    assert(strcmp(buf, "abc") == 0);

    assert(ft_strcpy(buf, "hello world") == buf);
    assert(strcmp(buf, "hello world") == 0);

    puts("ft_strcpy OK");
}

void test_strdup(void) {
    SEP();
    puts("ft_strdup");

    char *s;

    s = ft_strdup("");
    assert(s && strcmp(s, "") == 0);
    free(s);

    s = ft_strdup("abc");
    assert(s && strcmp(s, "abc") == 0);
    free(s);

    s = ft_strdup("hello world");
    assert(s && strcmp(s, "hello world") == 0);
    free(s);

    puts("ft_strdup OK");
}

void test_write(void) {
    SEP();
    puts("ft_write");

    errno = 0;
    ssize_t r = ft_write(1, "hello\n", 6);
    assert(r == 6);

    // Invalid fd
    errno = 0;
    r = ft_write(-1, "x", 1);
    assert(r == -1);
    assert(errno == EBADF);

    puts("ft_write OK");
}

void test_read(void) {
    SEP();
    puts("ft_read");

    char buf[16];

    // Read from stdin (manual test)
    puts("Type something and press enter:");
    ssize_t r = ft_read(0, buf, sizeof(buf) - 1);
    assert(r >= 0);
    buf[r] = '\0';
    printf("Read: \"%s\"\n", buf);

    // Invalid fd
    errno = 0;
    r = ft_read(-1, buf, 1);
    assert(r == -1);
    assert(errno == EBADF);

    puts("ft_read OK");
}

int main() {
    // ft_write(1, "hello\n", 6);
    // printf("errno: %d, msg: %s\n", errno, strerror(errno));
    // printf("%d\n", ft_strcmp("abc", "abcd"));
    // printf("%d\n", strcmp("abc", "abcd"));
    // printf("%zu\n", ft_strlen("abc"));
    // // char dest[4];
    // char *test = "abc";
    // char *dup = ft_strdup(test);
    // printf("%s\n", dup);
    test_strlen();
    test_strcmp();
    test_strcpy();
    test_strdup();
    // test_write();
    // test_read();
    // test_read_file();

    // puts("\nALL TESTS PASSED");
    // sbinprintf("hi");
    return 0;
}
