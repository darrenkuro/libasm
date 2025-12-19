; int	ft_list_size(t_list *begin_list)
; {
; 	int	count;

; 	if (!begin_list)
; 		return (0);
; 	count = 1;
; 	while (begin_list->next)
; 	{
; 		begin_list = begin_list->next;
; 		++count;
; 	}
; 	return (count);
; }
