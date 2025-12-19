; void	ft_list_push_front(t_list **begin_list, void *data)
; {
;     t_list	*node;

;     if (!begin_list)
;         return ;
; 	node = ft_create_elem(data);
; 	node->next = *begin_list;
; 	*begin_list = node;
; }
