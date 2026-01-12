CREATE DATABASE IF NOT EXISTS social_network_pro
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE social_network_pro;

-- Viết stored procedure
delimiter //
create procedure CalculateBonusPoints(
    in p_user_id int,
    inout p_bonus_points int
)
begin
    declare post_count int default 0;

    -- Đếm số bài viết của user
    select count(*) into post_count from posts
    where user_id = p_user_id;

    -- Cộng điểm thưởng
    if post_count >= 20 then
        set p_bonus_points = p_bonus_points + 100;
    elseif post_count >= 10 then
        set p_bonus_points = p_bonus_points + 50;
    end if;
end //
delimiter ; 
-- Gọi thủ tục 
set @bonus_points = 100;
call CalculateBonusPoints(3, @bonus_points);
--  Select ra p_bonus_points  
select @bonus_points as final_bonus_points;
--  Xóa thủ tục mới khởi tạo trên 
drop procedure CalculateBonusPoints; 