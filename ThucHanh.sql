create database SocialLab;
use SocialLab;

create table posts (
    post_id int auto_increment primary key,
    content text,
    author varchar(100),
    likes_count int default 0
);

delimiter //
-- Task 1
create procedure sp_CreatePost(
    in p_content text,
    in p_author varchar(100),
    out p_post_id int
)
begin
    insert into posts (content, author)
    values (p_content, p_author);

    set p_post_id = last_insert_id();
end //
delimiter ;
-- Task 2
delimiter //
create procedure sp_SearchPost(
    in p_keyword varchar(100)
)
begin
    select * from posts
    where content like concat('%', p_keyword, '%');
end //
delimiter ;
-- Task 3
delimiter //
  create procedure sp_IncreaseLike(
    in p_post_id int,
    inout p_likes int
)
begin
    update posts
    set likes_count = likes_count + 1
    where post_id = p_post_id;

    select likes_count into p_likes from posts
    where post_id = p_post_id;
end //
delimiter ;
-- Task 4
delimiter //
create procedure sp_DeletePost(
    in p_post_id int
)
begin
    delete from posts
    where post_id = p_post_id;
end //
delimiter ;
-- Tạo 2 bài viết mới và dùng biến để xem ID trả về
call sp_CreatePost('hello world', 'An', @post1_id);
call sp_CreatePost('hello mysql procedure', 'Binh', @post2_id);
select @post1_id as post1_id, @post2_id as post2_id;
-- Tìm kiếm các bài viết có chữ "hello" 
 call sp_SearchPost('hello');
-- tăng like
call sp_IncreaseLike(@post1_id, @likes);
select @likes as new_likes;
-- Xóa một bài viết bất kỳ 
call sp_DeletePost(@post2_id);
-- Xóa bỏ (Drop) tất cả các thủ tục đã tạo sau khi hoàn thành
 drop procedure if exists sp_CreatePost;
drop procedure if exists sp_SearchPost;
drop procedure if exists sp_IncreaseLike;
drop procedure if exists sp_DeletePost;
