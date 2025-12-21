# ------------------------ Project Metadata
NAME	:=	libasm
TARGET	:=	libasm.a

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
LIBDIR	:=	lib

# ------------------------ Files
_SRC	:=	ft_read.s ft_write.s ft_strlen.s ft_strcmp.s ft_strdup.s ft_strcpy.s \
			ft_atoi_base.s ft_list_push_front.s ft_list_remove_if.s ft_list_size.s \
			ft_list_sort.s
SRC		:=	$(addprefix $(SRCDIR)/, $(_SRC))
OBJ		:=	$(addprefix $(OBJDIR)/, $(_SRC:.s=.o))
_TEST	:=	main.c

# ------------------------ Toolchain & Flags
CC		:=	cc
CFLAGS	:=	-Wall -Wextra -Werror
LDFLAGS	:=	-L $(LIBDIR)
LDLIBS	:=	-lasm
AS		:=	$($(UNAME_S)_AS)
ASFLAGS	:=	$($(UNAME_S)_ASFLAGS)
AR		:=	ar rcs
RM		:=	rm -rf

# ------------------------ Build Settings
.DEFAULT_GOAL	:= all
PAD				?=	0

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
fclean: clean
	@if [ -f "$(TARGET)" ]; then \
		printf "%-*s Removing:  $(TARGET)..." $(PAD) "[$(NAME)]"; \
		$(RM) $(TARGET); \
		echo " ✅ "; \
	fi

.PHONY: re
re: fclean all

.PHONY: test
test: $(NAME)
	@$(CC) $(CFLAGS) $(SRCDIR)/$(_TEST) $(LDFLAGS) $(LDLIBS) -o $@ $(MUTE)
	@./$@
	@$(RM) $@

$(OBJDIR):
	@printf "%-*s Creating:  $@ directory..." $(PAD) "[$(NAME)]"
	@mkdir -p $@
	@echo " ✅ "

$(TARGET): $(OBJ)
	@printf "%-*s Building:  $@" $(PAD) "[$(NAME)]"
	@$(AR) $@ $^
	@echo " ✅ "

$(OBJDIR)/%.o: $(SRCDIR)/%.s | $(OBJDIR)
	@printf "%-*s Compiling: $<..." $(PAD) "[$(NAME)]"
	@$(AS) $(ASFLAGS) $< -o $@
	@echo " ✅ "

.DELETE_ON_ERROR:     # Delete target build that's incomplete
