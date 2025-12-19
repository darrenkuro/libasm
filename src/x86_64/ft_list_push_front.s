section .text
global ft_list_push_front
extern malloc

; t_list	*ft_create_elem(void *data)
; {
; 	t_list	*elem;

; 	elem = malloc(sizeof(t_list));
;     if (!elem)
;         return (NULL);
; 	elem->data = data;
; 	elem->next = NULL;
; 	return (elem);
; }
; void	ft_list_push_front(t_list **begin_list, void *data)
; {
;     t_list	*node;

;     if (!begin_list)
;         return ;
; 	node = ft_create_elem(data);
; 	node->next = *begin_list;
; 	*begin_list = node;
; }
