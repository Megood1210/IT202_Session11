CREATE DATABASE IF NOT EXISTS social_network_pro
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE social_network_pro;

-- Viết stored procedure
delimiter //
create procedure CalculateUserActivityScore(
    in p_user_id int,
    out activity_score int,
    out activity_level varchar(50)
)
begin
    set activity_score =
        (
            select count(*) 
            from posts 
            where user_id = p_user_id
        ) * 10
        +
        (
            select count(*) 
            from comments 
            where user_id = p_user_id
        ) * 5
        +
        (
            select count(*)
            from posts p
            join likes l on p.post_id = l.post_id
            where p.user_id = p_user_id
        ) * 3;

    if activity_score > 500 then
        set activity_level = 'Rất tích cực';
    elseif activity_score between 200 and 500 then
        set activity_level = 'Tích cực';
    else
        set activity_level = 'Bình thường';
    end if;
end //
delimiter ;
-- Gọi thủ tục
call CalculateUserActivityScore(1, @score, @level);
select @score as activity_score,@level as activity_level;
-- Xóa thủ tục
drop procedure CalculateUserActivityScore;