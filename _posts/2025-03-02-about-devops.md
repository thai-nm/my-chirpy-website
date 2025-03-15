---
title: "Tản mạn: DevOps là gì?"
author: thainm
date: 2025-03-02 00:00:00 +0700
categories: [Tản mạn]
tags: [tản mạn]
---

## Giới thiệu
Chào các bạn, đây là bài viết đầu tiên của mình về DevOps 😃

Sau một hồi đắn đo trong việc lên ý tưởng cho bài viết này, mình quyết định chọn cách trả lời cho một câu hỏi, có lẽ đã xuất hiện trong đầu của bất cứ ai theo đuổi vị trí này: `DevOps là gì?`

![img-its-devops](../assets/posts/2025-03-02-about-devops/img/its-devops.png)

Bài viết được trình bày dưới góc nhìn chủ quan của mình, với 3 năm kinh nghiệm làm DevOps Engineer tại 1 công ty outsourcing và mới chuyển sang 1 công ty product gần đây.

Mục đích của bài viết:
- Chia sẻ quan điểm tới cộng đồng.
- Dành cho các bạn quan tâm và muốn tìm hiểu về DevOps: Mình mới ra trường chưa lâu, và mình muốn nhân lúc còn nhớ những băn khoăn, thắc mắc khi lơ mơ nghe tới DevOps, mình có thể chia sẻ tới các bạn (đặc biệt là sinh viên), mong rằng có thể phần nào giúp các bạn hiểu rõ hơn.  
- Viết cho mình trong tương lai. Mình khá tò mò không biết vài năm nữa góc nhìn của mình liệu có thay đổi gì hay không 😃

Lan man thế đủ rồi, vào vấn đề thoi 😃 

## DevOps là gì?
Trong quy trình phát triển phần mềm, bằng việc liên tục đưa ra các bản cập nhật mới với từng thay đổi nhỏ của ứng dụng thay vì lên kế hoạch với timeline dài dằng dặc cùng nhiều thay đổi lớn, đội ngũ phát triển sẽ nhận được phản hồi từ phía khách hàng/người dùng sớm hơn, đồng nghĩa với việc sớm có kế hoạch thay đổi code hoặc đưa ra các bản vá lỗi/cải tiến. Ngoài ra, các thay đổi nhỏ nếu có gây ra lỗi thường sẽ dễ xử lý hơn các thay đổi lớn. Để đáp ứng được việc liên tục đưa ra các bản cập nhật mới như vậy, ta cần một cách thức nào đó giúp __giảm thời gian__ đưa sản phẩm tới tay người dùng mà vẫn __giữ được chất lượng tốt__, và ta có: __DevOps__.

Khi tra định nghĩa DevOps trên Google, rất có thể các bạn đã bắt gặp định nghĩa kiểu như: "DevOps là một văn hoá/phương thức/nguyên lý ...". Các định nghĩa này theo mình đều đúng, nhưng gây khó hiểu và khó hình dung cho người đọc, đặc biệt với những người mới tìm hiểu về DevOps. Trong bài viết này, mình đưa ra định nghĩa của mình về DevOps engineer, điều mà mình cho là thực tế và rõ ràng hơn. 

DevOps engineer là những người:
- __Tự động hoá việc triển khai với việc phát triển ứng dụng__: Thông thường ở một dự án phát triển phần mềm, ứng dụng sẽ được triển khai tới từng môi trường tương ứng với từng giai đoạn: `dev -> qa -> staging -> production`. Thay vì triển khai thủ công trên từng môi trường mỗi khi có yêu cầu, việc tự động hoá triển khai (thường bằng CI/CD pipeline) giúp giảm thời gian thao tác, hạn chế rủi ro khi làm thủ công (con người làm có thể gây ra lỗi, càng làm nhiều thì khả năng gây ra lỗi càng lớn, và lỗi thì cần thời gian để sửa 😃). 

    Ví dụ: Team QA cần service `user-management-service` trên môi trường `QA` để chạy test. Sử dụng các CI/CD platform như [Jenkins](https://www.jenkins.io/) hay [GitHub Actions](https://github.com/features/actions), QA engineer chỉ việc chọn service cần triển khai và ấn nút `Deploy`, đợi vài phút (thường là vậy 😁) cho pipeline chạy xong là sẽ có service `user-management-service` trên môi trường `QA` để cả team tha hồ test. Các pipeline để tự động hoá việc triển khai này không tự dưng có, mà sẽ được team DevOps phát triển.

- __Quản lý cơ sở hạ tầng__: Như đã đề cập ở trên, mỗi dự án sẽ có nhiều môi trường. DevOps là những người tạo/cập nhật/xoá cơ sở hạ tầng như server, database trên các môi trường. Nếu mỗi môi trường lại phải quản lý thủ công thì sẽ mất rất nhiều thời gian (và chán), đồng thời tiềm ẩn nhiều rủi ro, xoá nhầm hay cấu hình sai một database chẳng hạn. Lúc này, tự động hoá việc thao tác với hệ thống là rất cần thiết, và ta có [Terraform](https://www.terraform.io/) được sử dụng rộng rãi, giúp ta cấu hình server, database hay cơ sở hạ tầng nói chung thông qua code.

- __Giám sát và khắc phục sự cố hệ thống__: Giả sử ứng dụng của mình đột nhiên được biết đến rộng rãi, nhà nhà người người tải xuống và dùng khiến lượng request tăng cao đột biến, mình cần phải tăng CPU/memory cho database để có thể chịu tải được. Để nhận biết được điều này sớm, cần có những phương án hay công cụ để theo dõi được tình trạng hệ thống ứng dụng, và mình có thể tìm tới combo ngon bổ miễn phí [Prometheus](https://prometheus.io/) kết hợp với [Grafana](https://grafana.com/). Tất nhiên, cái này DevOps làm nốt 😁.

Vậy cụ thể hơn, công việc hàng ngày của DevOps engineer sẽ có gì?

## Công việc hàng ngày của DevOps engineer
placeholder

## Thách thức và cơ hội
placeholder

## FAQ thường thấy
- Roadmap?
- Lương cao không?
- Cạnh tranh và làn sóng AI?
- Làm DevOps có phải code không?

## Tham khảo
- Agile
- Quy trình phát triển phần mềm
- DevOps