; void ft_list_sort(t_list **begin_list, int (*cmp)())
; (*cmp)(list_ptr->data, list_other_ptr->data)

	; void ft_list_sort(t_list **begin_list, int (*cmp)())
	; {
	; t_list *curr
	; int  swapped
	; void *tmp

	; if (!begin_list || !*begin_list)
	; return

	; swapped = 1
	; while (swapped)
	; {
	; swapped = 0
	; curr = *begin_list
	; while (curr->next)
	; {
	; if (cmp(curr->data, curr->next->data) > 0)
	; {
	; tmp = curr->data
	; curr->data = curr->next->data
	; curr->next->data = tmp
	; swapped = 1
	; }
	; curr = curr->next
	; }
	; }
	; }
