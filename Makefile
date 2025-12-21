# ------------------------ Project Metadata
NAME	:=	libasm
TARGET	:=	libasm.a
TARGET_B:=	libasm_bonus.a

# ------------------------ OS & Architecture
UNAME_S			:=	$(shell uname -s)
Darwin_ARCH		:=	arm64
Darwin_AS		:=	as
Darwin_ASFLAGS	:=
Linux_ARCH		:=	x86_64
Linux_AS		:=	nasm
Linux_ASFLAGS	:=	-f elf64
ARCH			:=	$($(UNAME_S)_ARCH)

ifeq ($(ARCH),)
$(error Unsupported OS: $(UNAME_S))
endif

# ------------------------ Directories
OBJROOT	:=	obj
SRCDIR	:=	src/$(ARCH)
OBJDIR	:=	$(addprefix $(OBJROOT)/, $(ARCH))
LIBDIR	:=	.
TESTDIR	:=	test

# ------------------------ Files
SRC		:=	ft_read.s ft_write.s ft_strlen.s ft_strcmp.s ft_strdup.s ft_strcpy.s
SRC_B	:=	ft_atoi_base_bonus.s ft_list_push_front_bonus.s \
			ft_list_remove_if_bonus.s ft_list_size_bonus.s \
			ft_list_sort_bonus.s
OBJ		:=	$(addprefix $(OBJDIR)/, $(SRC:.s=.o))
OBJ_B	:=	$(addprefix $(OBJDIR)/, $(SRC_B:.s=.o))
TEST	:=	$(addprefix $(TESTDIR)/, main_b.c)
TEST_B	:=	$(addprefix $(TESTDIR)/, main_bonus.c)

# ------------------------ Toolchain & Flags
CC		:=	cc
CFLAGS	:=	-Wall -Wextra -Werror
LDFLAGS	:=	-L $(LIBDIR)
AS		:=	$($(UNAME_S)_AS)
ASFLAGS	:=	$($(UNAME_S)_ASFLAGS)
AR		:=	ar rcs
RM		:=	rm -rf

lib_ldflag = -l $(patsubst lib%.a,%,$(notdir $1))

# ------------------------ Build Settings
.DEFAULT_GOAL	:= all
PAD				?=	0

define BUILD_RULE
$1: $2
	@printf "%-*s Building:  $$@" $(PAD) "[$(NAME)]"
	@$(AR) $$@ $$^
	@echo " ✅ "

.PHONY: test-$1
test-$1: $1
	@printf "%-*s Compiling: test for $1..." $(PAD) "[$(NAME)]"
	@$(CC) $(CFLAGS) $3 $(LDFLAGS) $(call lib_ldflag,$1) -o $$@
	@echo " ✅ "
	@printf "%-*s Running:   test for $1...\n" $(PAD) "[$(NAME)]"
	@set -o pipefail; ./$$@ 2>&1 | sed 's/^/    - /' || exit $$?;
	@printf "%-*s Removing:  test for $1..." $(PAD) "[$(NAME)]"
	@$(RM) $$@
	@echo " ✅ "

.PHONY: fclean-$1
fclean-$1: clean
	@if [ -f "$1" ]; then \
		printf "%-*s Removing:  $1..." $(PAD) "[$(NAME)]"; \
		$(RM) $1; \
		echo " ✅ "; \
	fi
endef

$(eval $(call BUILD_RULE,$(TARGET),$(OBJ),$(TEST)))
$(eval $(call BUILD_RULE,$(TARGET_B),$(OBJ_B),$(TEST_B)))

.PHONY: all
all: $(TARGET) $(TARGET_B)

.PHONY: clean
clean:
	@if [ -d "$(OBJROOT)" ]; then \
		printf "%-*s Removing:  $(OBJROOT)/..." $(PAD) "[$(NAME)]"; \
		$(RM) -r $(OBJROOT); \
		echo " ✅ "; \
	fi

.PHONY: fclean
fclean: fclean-$(TARGET) fclean-$(TARGET_B)

.PHONY: re
re: fclean all

.PHONY: bonus
bonus: $(TARGET_B)

.PHONY: test
test: test-$(TARGET)

.PHONY: test-bonus
test-bonus: test-$(TARGET_B)

$(OBJDIR):
	@printf "%-*s Creating:  $@ directory..." $(PAD) "[$(NAME)]"
	@mkdir -p $@
	@echo " ✅ "

$(OBJDIR)/%.o: $(SRCDIR)/%.s | $(OBJDIR)
	@printf "%-*s Compiling: $<..." $(PAD) "[$(NAME)]"
	@$(AS) $(ASFLAGS) $< -o $@
	@echo " ✅ "

.DELETE_ON_ERROR:   # Delete target build that's incomplete
