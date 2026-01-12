CREATE DATABASE IF NOT EXISTS social_network_pro
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE social_network_pro;

-- Viết stored procedure
delimiter //
create procedure NotifyFriendsOnNewPost(
    in p_user_id int,
    in p_content text
)
begin
    -- thêm bài viết
    insert into posts(user_id, content, created_at)
    values (p_user_id, p_content, now());
    -- gửi thông báo cho friends (user_id -> friend_id)
    insert into notifications(user_id, type, content, is_read, created_at)
    select f.friend_id, 'new_post', concat(u.full_name, ' đã đăng một bài viết mới'), 0, now() from friends f
    join users u on u.user_id = p_user_id
    where f.user_id = p_user_id
      and f.status = 'accepted'
      and f.friend_id <> p_user_id;
    -- gửi thông báo cho friends (friend_id -> user_id)
    insert into notifications(user_id, type, content, is_read, created_at)
    select f.user_id, 'new_post', concat(u.full_name, ' đã đăng một bài viết mới'), 0, now() from friends f
    join users u on u.user_id = p_user_id
    where f.friend_id = p_user_id
      and f.status = 'accepted'
      and f.user_id <> p_user_id;
    -- trả kết quả kiểm tra
    select last_insert_id() as post_id,
           'Tạo bài viết & gửi thông báo thành công' as result;
end //
delimiter ;
-- Gọi thủ tục
call NotifyFriendsOnNewPost(1, 'Hôm nay mình học xong Stored Procedure');
-- Select ra những thông báo của bài viết vừa đăng
select notification_id, user_id, content, created_at from notifications
where type = 'new_post'
order by created_at desc;
-- Xóa thủ tục
drop procedure NotifyFriendsOnNewPost;