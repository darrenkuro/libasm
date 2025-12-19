; int	validate_base(char *base)
; {
; 	char	checked[255];
; 	int		count;
; 	int		i;

; 	count = 0;
; 	i = 0;
; 	while (*base)
; 	{
; 		i = 0;
; 		if (*base == '+' || *base == '-' || (*base >= 9 && *base <= 13)
; 			|| *base == ' ' || *base <= 31)
; 			return (0);
; 		while (i < count)
; 		{
; 			if (*base == checked[i])
; 				return (0);
; 			++i;
; 		}
; 		checked[i] = *base;
; 		++count;
; 		++base;
; 	}
; 	if (count < 1)
; 		return (0);
; 	return (count);
; }

; int	read_num(char *str, char *base, int digit)
; {
; 	int	num;
; 	int	i;

; 	num = 0;
; 	while (*str)
; 	{
; 		i = 0;
; 		while (base[i] != *str)
; 		{
; 			if (!base[i])
; 				return (num);
; 			++i;
; 		}
; 		num = num * digit + i;
; 		++str;
; 	}
; 	return (num);
; }

; int	ft_atoi_base(char *str, char *base)
; {
; 	int	digit;
; 	int	neg;

; 	neg = 1;
; 	digit = validate_base(base);
; 	if (digit == 0)
; 		return (0);
; 	while (*str == ' ' || (*str >= 9 && *str <= 13))
; 		++str;
; 	while (*str == '+' || *str == '-')
; 	{
; 		if (*str == '-')
; 			neg = -neg;
; 		++str;
; 	}
; 	return (neg * read_num(str, base, digit));
; }
