#
## utils
CC	=	gcc

RM	=	rm -f

#
## binary's name
NAME	=	a.out

#
## project paths
SOURCE	=	.

#
## project C source code
SRCS	=	$(SOURCE)/main.c

#
## project object code
OBJS	=	$(SRCS:.c=.o)

#
## compilation flags
# CFLAGS	+=	-W -Wall -Wextra -Werror
CFLAGS	+=	-I /usr/include/libpurple/
CFLAGS	+=	-I /usr/include/glib-2.0/ -I /usr/lib/glib-2.0/include/
# CFLAGS	+=	-ggdb
LDFLAGS	+=	-lpurple
LDFLAGS	+=	`pkg-config --libs glib-2.0`


all:		$(NAME)

$(NAME):	$(OBJS)
		$(CC) $(LDFLAGS) $(OBJS) -o $(NAME) $(CFLAGS)

clean:
		$(RM) $(OBJS)

fclean:		clean
		$(RM) $(NAME)

re:		fclean all

.PHONY:		all clean fclean re
