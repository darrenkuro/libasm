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
SRCDIR	:=	src/$(ARCH)
OBJDIR	:=	obj/$(ARCH)
TESTDIR	:=	test

# ------------------------ Files
SRC		:=	ft_read.s ft_write.s ft_strlen.s ft_strcmp.s ft_strdup.s ft_strcpy.s
SRC_B	:=	ft_atoi_base_bonus.s ft_list_push_front_bonus.s \
			ft_list_remove_if_bonus.s ft_list_size_bonus.s \
			ft_list_sort_bonus.s
OBJ		:=	$(addprefix $(OBJDIR)/, $(SRC:.s=.o))
OBJ_B	:=	$(addprefix $(OBJDIR)/, $(SRC_B:.s=.o))
TEST	:=	$(addprefix $(TESTDIR)/, main.c)
TEST_B	:=	$(addprefix $(TESTDIR)/, main_bonus.c)

# ------------------------ Toolchain & Flags
CC		:=	cc
CFLAGS	:=	-Wall -Wextra -Werror
LDFLAGS	:=	-L.
LDLIBS	:=	-lasm
AS		:=	$($(UNAME_S)_AS)
ASFLAGS	:=	$($(UNAME_S)_ASFLAGS)
AR		:=	ar rcs
RM		:=	rm -rf

# ------------------------ Build Settings
.DEFAULT_GOAL	:= all
PAD				?=	0

define BUILD_RULE
$1: $2
	@printf "%-*s Building:  $$@" $(PAD) "[$(NAME)]"
	@$(AR) $$@ $$^
	@echo " ✅ "

.PHONY: test-$(basename $1)
test-$(basename $1): $1
	@$(CC) $(CFLAGS) $3 $(LDFLAGS) $(LDLIBS) -o $$@
	@./$$@
	@$(RM) $$@

.PHONY: fclean-$(basename $1)
fclean-$(basename $1): clean
	@if [ -f "$1" ]; then \
		printf "%-*s Removing:  $1..." $(PAD) "[$(NAME)]"; \
		$(RM) $1; \
		echo " ✅ "; \
	fi
endef

$(eval $(call BUILD_RULE,$(TARGET),$(OBJ),$(TEST)))
$(eval $(call BUILD_RULE,$(TARGET_B),$(OBJ_B),$(TEST_B)))

.PHONY: all
all: $(TARGET)

.PHONY: clean
clean:
	@if [ -d "$(OBJDIR)" ]; then \
		printf "%-*s Removing:  $(OBJDIR)/..." $(PAD) "[$(NAME)]"; \
		$(RM) -r $(OBJDIR); \
		echo " ✅ "; \
	fi

.PHONY: fclean
fclean: fclean-$(basename $(TARGET)) fclean-$(basename $(TARGET_B))

.PHONY: re
re: fclean all

.PHONY: bonus
bonus: $(TARGET_B)

.PHONY: test
test: test-$(basename $(TARGET))

.PHONY: test-bonus
test-bonus: test-$(basename $(TARGET_B))

$(OBJDIR):
	@printf "%-*s Creating:  $@ directory..." $(PAD) "[$(NAME)]"
	@mkdir -p $@
	@echo " ✅ "

$(OBJDIR)/%.o: $(SRCDIR)/%.s | $(OBJDIR)
	@printf "%-*s Compiling: $<..." $(PAD) "[$(NAME)]"
	@$(AS) $(ASFLAGS) $< -o $@
	@echo " ✅ "

.DELETE_ON_ERROR:     # Delete target build that's incomplete
