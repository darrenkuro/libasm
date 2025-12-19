; void	ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(),
; 	void (*free_fct)(void *))
; {
;     t_list	*curr;
; 	t_list	*prev;
; 	t_list	*tmp;

; 	if (!begin_list || !*begin_list)
; 		return ;

; 	curr = *begin_list;
; 	prev = (void *) 0;
; 	while (curr)
; 	{
; 		if (cmp(curr->data, data_ref) == 0)
; 		{
; 			tmp = curr;
; 			if (prev)
; 				prev->next = curr->next;
; 			else
; 				*begin_list = curr->next;
; 			curr = curr->next;
; 			free_fct(tmp->data);
; 			free(tmp);
; 		}
; 		else
; 		{
; 			prev = curr;
; 			curr = curr->next;
; 		}
; 	}
; }
