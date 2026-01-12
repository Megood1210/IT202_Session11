CREATE DATABASE IF NOT EXISTS social_network_pro
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE social_network_pro;

-- Viết stored procedure
delimiter //
create procedure CreatePostWithValidation(
    in p_user_id int,
    in p_content text,
    out result_message varchar(255)
)
begin
    if char_length(p_content) < 5 then
        set result_message = 'Nội dung quá ngắn';
    else
        insert into posts(user_id, content, created_at)
        values (p_user_id, p_content, now());

        set result_message = 'Thêm bài viết thành công';
    end if;
end //
delimiter ;
--  Gọi thủ tục và thử insert các trường hợp
call CreatePostWithValidation(1, 'Hi', @msg1);
call CreatePostWithValidation(1, 'Hello MySQL', @msg2);
-- Kiểm tra các kết quả 
select @msg1 as result_1;
select @msg2 as result_2;
-- Xóa thủ tục vừa khởi tạo trên
drop procedure CreatePostWithValidation; 