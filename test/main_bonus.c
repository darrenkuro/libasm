#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* ===== libasm bonus prototypes ===== */

typedef struct s_list {
    void *data;
    struct s_list *next;
} t_list;

int ft_atoi_base(char *str, char *base);
void ft_list_push_front(t_list **begin_list, void *data);
int ft_list_size(t_list *begin_list);
void ft_list_sort(t_list **begin_list, int (*cmp)());
void ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(), void (*free_fct)(void *));

/* ===== test macros ===== */

#define SEP() puts("--------------------------------------------------")
#define TEST_OK(desc)                                                                              \
    do {                                                                                           \
        printf("%-35s ✅\n", desc);                                                                \
        pass++;                                                                                    \
    } while (0)

#define TEST_FAIL(desc, fmt, ...)                                                                  \
    do {                                                                                           \
        printf("%-35s ❌ (" fmt ")\n", desc, ##__VA_ARGS__);                                       \
    } while (0)

/* ===== helpers ===== */

static t_list *lst_new(void *data) {
    t_list *n = malloc(sizeof(*n));
    if (!n)
        return NULL;
    n->data = data;
    n->next = NULL;
    return n;
}

static void lst_clear(t_list **lst) {
    t_list *tmp;
    while (*lst) {
        tmp = (*lst)->next;
        free((*lst)->data);
        free(*lst);
        *lst = tmp;
    }
}

static int cmp_str(void *a, void *b) {
    return strcmp(a, b);
}

static void free_str(void *p) {
    free(p);
}

/* ===== tests ===== */

static void test_atoi_base(void) {
    SEP();
    puts("Testing ft_atoi_base");

    struct {
        char *str;
        char *base;
        int expected;
        char *desc;
    } tests[] = {
        {"42", "0123456789", 42, "decimal"},
        {"2A", "0123456789ABCDEF", 42, "hex"},
        {"-101010", "01", -42, "binary negative"},
        {"   +42", "0123456789", 42, "leading whitespace"},
        {"123", "0", 0, "base too short"},
        {"123", "1123", 0, "duplicate in base"},
        {"123", "+0123", 0, "invalid char in base"},
        {"zzz", "z", 0, "single-char base"},
    };

    size_t count = sizeof(tests) / sizeof(tests[0]);
    size_t pass = 0;

    for (size_t i = 0; i < count; i++) {
        int got = ft_atoi_base(tests[i].str, tests[i].base);
        if (got == tests[i].expected)
            TEST_OK(tests[i].desc);
        else
            TEST_FAIL(tests[i].desc, "expected %d, got %d", tests[i].expected, got);
    }

    printf("%-35s %s %zu/%zu\n", "ft_atoi_base:", pass == count ? "✅" : "⚠️", pass, count);
}

static void test_list_push_front(void) {
    SEP();
    puts("Testing ft_list_push_front");

    size_t pass = 0;
    size_t count = 1;
    t_list *lst = NULL;

    ft_list_push_front(&lst, strdup("c"));
    ft_list_push_front(&lst, strdup("b"));
    ft_list_push_front(&lst, strdup("a"));

    if (lst && strcmp(lst->data, "a") == 0 && strcmp(lst->next->data, "b") == 0 &&
        strcmp(lst->next->next->data, "c") == 0)
        TEST_OK("push_front order");
    else
        TEST_FAIL("push_front order", "wrong list structure");

    lst_clear(&lst);

    printf("%-35s %s %zu/%zu\n", "ft_list_push_front:", pass == count ? "✅" : "⚠️", pass, count);
}

static void test_list_size(void) {
    SEP();
    puts("Testing ft_list_size");

    size_t pass = 0;
    size_t count = 2;

    t_list *lst = NULL;
    if (ft_list_size(lst) == 0)
        TEST_OK("empty list");
    else
        TEST_FAIL("empty list", "expected 0");

    lst = lst_new(strdup("a"));
    lst->next = lst_new(strdup("b"));
    lst->next->next = lst_new(strdup("c"));

    if (ft_list_size(lst) == 3)
        TEST_OK("3 elements");
    else
        TEST_FAIL("3 elements", "expected 3");

    lst_clear(&lst);

    printf("%-35s %s %zu/%zu\n", "ft_list_size:", pass == count ? "✅" : "⚠️", pass, count);
}

static void test_list_sort(void) {
    SEP();
    puts("Testing ft_list_sort");

    size_t pass = 0;
    size_t count = 1;

    t_list *lst = NULL;
    ft_list_push_front(&lst, strdup("banana"));
    ft_list_push_front(&lst, strdup("apple"));
    ft_list_push_front(&lst, strdup("cherry"));

    ft_list_sort(&lst, cmp_str);

    if (strcmp(lst->data, "apple") == 0 && strcmp(lst->next->data, "banana") == 0 &&
        strcmp(lst->next->next->data, "cherry") == 0)
        TEST_OK("sorted order");
    else
        TEST_FAIL("sorted order", "incorrect");

    lst_clear(&lst);

    printf("%-35s %s %zu/%zu\n", "ft_list_sort:", pass == count ? "✅" : "⚠️", pass, count);
}

static void test_list_remove_if(void) {
    SEP();
    puts("Testing ft_list_remove_if");

    size_t pass = 0;
    size_t count = 1;

    t_list *lst = NULL;
    ft_list_push_front(&lst, strdup("keep"));
    ft_list_push_front(&lst, strdup("rm"));
    ft_list_push_front(&lst, strdup("keep"));
    ft_list_push_front(&lst, strdup("rm"));

    ft_list_remove_if(&lst, "rm", cmp_str, free_str);

    if (ft_list_size(lst) == 2 && strcmp(lst->data, "keep") == 0 &&
        strcmp(lst->next->data, "keep") == 0)
        TEST_OK("remove_if");
    else
        TEST_FAIL("remove_if", "unexpected list");

    lst_clear(&lst);

    printf("%-35s %s %zu/%zu\n", "ft_list_remove_if:", pass == count ? "✅" : "⚠️", pass, count);
}

/* ===== main ===== */

int main(void) {
    test_atoi_base();
    test_list_push_front();
    test_list_size();
    test_list_sort();
    test_list_remove_if();
    return 0;
}
