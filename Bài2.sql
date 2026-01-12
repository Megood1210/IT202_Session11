CREATE DATABASE IF NOT EXISTS social_network_pro
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE social_network_pro;

--  Tính tổng like của bài viết
delimiter //
create procedure CalculatePostLikes(
    in p_post_id int,
    out total_likes int
)
begin
    select count(*) 
    into total_likes
    from likes
    where post_id = p_post_id;
end //
delimiter ;
-- Gọi stored procedure 
set @total_likes = 0;
call CalculatePostLikes(105, @total_likes);
select @total_likes as total_likes;
-- Xóa thủ tục vừa mới tạo trên 
drop procedure CalculatePostLikes;