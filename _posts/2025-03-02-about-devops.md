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
- Dành cho các bạn quan tâm và muốn tìm hiểu về DevOps: Mình mới ra trường chưa lâu, và nhân lúc còn nhớ những băn khoăn, thắc mắc khi lần đầu nghe tới DevOps, mình có thể chia sẻ tới các bạn (đặc biệt là sinh viên), mong rằng có thể phần nào giúp các bạn hiểu rõ hơn.  
- Viết cho mình trong tương lai. Mình khá tò mò không biết vài năm nữa góc nhìn của mình liệu có thay đổi gì hay không 😃

## DevOps là gì?

Trong phát triển phần mềm, việc liên tục đưa ra các bản cập nhật với từng thay đổi nhỏ giúp nhận phản hồi từ khách hàng sớm hơn. Điều này cho phép điều chỉnh code kịp thời và giảm rủi ro khi triển khai. Ngoài ra, các thay đổi nhỏ nếu có gây ra lỗi thường sẽ dễ xử lý hơn các thay đổi lớn. Để đáp ứng được việc liên tục đưa ra các bản cập nhật như vậy, ta cần một cách thức nào đó giúp __giảm thời gian__ đưa sản phẩm tới tay người dùng mà vẫn __giữ được chất lượng tốt__, và ta có: __DevOps__.

Khi tra định nghĩa DevOps trên Google, rất có thể các bạn đã bắt gặp định nghĩa kiểu như: "DevOps là một văn hoá/phương thức/nguyên lý ...". Các định nghĩa này theo mình đều đúng, nhưng trừu tượng và khó hình dung cho người đọc, đặc biệt với những người mới tìm hiểu về DevOps. Trong bài viết này, mình đưa ra định nghĩa của mình về DevOps engineer, điều mà mình cho là thực tế và rõ ràng hơn.

DevOps engineer là những người:

- __Tự động hoá việc triển khai với việc phát triển ứng dụng__: Thông thường ở một dự án phát triển phần mềm, ứng dụng sẽ được triển khai tới từng môi trường tương ứng với từng giai đoạn: `dev -> qa -> staging -> production`. Thay vì deploy (triển khai) thủ công trên từng môi trường mỗi khi có yêu cầu, việc tự động deploy (thường bằng CI/CD pipeline) giúp giảm thời gian thao tác, hạn chế rủi ro khi làm thủ công (con người làm có thể gây ra lỗi, càng làm nhiều thì khả năng gây ra lỗi càng lớn, và lỗi thì cần thời gian để sửa 😃). 

    Ví dụ: Team QA cần service `user-management-service` trên môi trường `QA` để chạy test. Sử dụng các CI/CD platform như [Jenkins](https://www.jenkins.io/) hay [GitHub Actions](https://github.com/features/actions), QA engineer chỉ việc chọn service cần triển khai và ấn nút `Deploy`, đợi vài phút (thường là vậy 😁) cho pipeline chạy xong là sẽ có service `user-management-service` trên môi trường `QA` để cả team tha hồ test. Các pipeline tự động deploy này không tự dưng có, mà sẽ được team DevOps phát triển.

    ![img-jenkins-cicd-pipeline](../assets/posts/2025-03-02-about-devops/img/sample-jenkins-cicd-pipeline.png) <em>Một CI/CD pipeline trên Jenkins</em>

- __Quản lý cơ sở hạ tầng (infrastructure)__: Như đã đề cập ở trên, mỗi dự án sẽ có nhiều môi trường. DevOps là những người tạo/cập nhật/xoá infrastructure như máy chủ (server), database trên các môi trường. Nếu mỗi môi trường lại phải quản lý thủ công thì sẽ mất rất nhiều thời gian (và nhàm chán), đồng thời tiềm ẩn nhiều rủi ro, xoá nhầm hay cấu hình sai một database chẳng hạn. Lúc này, tự động hoá tương tác với hệ thống là rất cần thiết, và ta có [Terraform](https://www.terraform.io/) được sử dụng rộng rãi, giúp ta cấu hình server, database hay infrastructure nói chung thông qua code.

    Dưới đây là một đoạn code Terraform để tạo một VM (virtual machine) trên AWS:

    ```terraform
    provider "aws" {
        region = "us-east-1"
    }

    resource "aws_instance" "terraform_vm" {
        ami           = "ami-0c55b159cbfafe1f0"
        instance_type = "t2.micro" 

        tags = {
            Name = "Terraform-VM"
        }
    }

    output "instance_ip" {
        description = "Public IP of the  instance"
        value       = aws_instance.terraform_vm.public_ip
    }
    ```

- __Giám sát (monitoring) và khắc phục sự cố hệ thống__: Giả sử ứng dụng của mình đột nhiên được biết đến rộng rãi, nhà nhà người người tải xuống và dùng khiến lượng request tăng cao đột biến, mình cần phải tăng CPU/memory cho database để có thể chịu tải được. Để nhận biết được điều này sớm, cần có những phương án hay công cụ để theo dõi được tình trạng hệ thống ứng dụng, và mình có thể tìm tới combo ngon bổ miễn phí [Prometheus](https://prometheus.io/) kết hợp với [Grafana](https://grafana.com/). Tất nhiên, cái này DevOps làm nốt 😁.

    ![img-grafana-dashboard](../assets/posts/2025-03-02-about-devops/img/sample-grafana-dashboard.png) <em> Dashboard trên Grafana </em>

Trên thực tế, team DevOps làm việc rất chặt chẽ với các team khác nhau như:

- __Team backend/frontend (a.k.a team dev)__: DevOps engineer là người chịu trách nhiệm chính trong việc deploy ứng dụng, mỗi ứng dụng lại cần cấu hình và cài đặt khác nhau nên DevOps engineer cần làm việc trực tiếp với team dev để nắm được ứng dụng cần gì để build được và chạy được.
- __Team tester và QA__: DevOps engineer làm việc cùng với team tester và QA để hiểu và đưa việc chạy test như unit test, smoke test, integration test vào trong các pipeline để tự động hoá việc chạy các loại test này. Các test mà team tester tạo ra có thể được chạy riêng biệt hoặc cùng với pipeline để deploy ứng dụng. Một ví dụ đơn giản là chỉ khi pass test case A thì ứng dụng mới được deploy lên môi trường staging, và sau khi ứng dụng đã được deploy này pass test case B thì mới được deploy lên môi trường production.

    ![img-automation-test-pipeline](../assets/posts/2025-03-02-about-devops/img/sample-devops-automation-test-pipeline.png) <em> Hình minh hoạ về quy trình của một automation test pipeline </em>

- __Team IT__: Ở một số công ty, team IT quản lý cấu hình về mạng nội bộ, server vật lý nội bộ và hệ thống quản lý quyền truy cập (Active Directory) của nhân viên trong công ty. Team DevOps phối hợp với team IT để làm những nhiệm vụ như sử dụng Active Directory của công ty để kết nối tới các bên thứ ba cung cấp dịch vụ (Azure, AWS, ...), từ đó cho phép nhân viên dùng thông tin tài khoản của công ty để truy cập các dịch vụ của các bên này.

Và còn làm việc với rất nhiều vị trí khác nữa.

## Công việc hàng ngày của DevOps engineer

Bắt nguồn từ những trách nhiệm kể trên, một ngày làm DevOps engineer của mình thường gồm những đầu việc như:

- __Theo dõi hệ thống và xử lý sự cố__: team dev không gọi được API của service A trên môi trường `staging` do lỗi hệ thống mạng; ứng dụng bị crash liên tục do không kết nối được tới database, ...
- __Phát triển pipeline để tự động hoá và tích hợp thêm chức năng mới__: Thêm bước lưu kết quả các test case thành file `.zip` và cho phép tải xuống; thêm bước yêu cầu xác nhận thủ công của sếp trước khi deploy lên môi trường `production`; ...
- __Bảo trì hệ thống và nâng cao bảo mật__: nâng version của Jenkins server lên bản mới nhất để nhận những bản vá bảo mật (security patch) mới nhất; chuyển từ cấp toàn bộ quyền cho một người thành chỉ cấp những quyền cần thiết, thiếu thì yêu cầu xin thêm; ...
- __Quản lý infrastructure__: Tạo một database cho môi trường dev; tự động tắt server ngoài giờ làm việc để giảm chi phí; ...
- ...

Các bạn có thể tham khảo thêm các job description (JD) trên mạng để nắm được về yêu cầu và công việc của DevOps engineer, ví dụ như [đây](https://business.linkedin.com/talent-solutions/resources/how-to-hire-guides/devops-engineer/job-description) là một JD mẫu trên Linkedin.

## Thách thức và cơ hội

### Thách thức

- __Khả năng tự học__: Do tech stack của DevOps engineer cực kỳ đa dạng, từ tầng ứng dụng, networking tới cả ảo hoá phần cứng, việc liên tục tìm hiểu thêm là bắt buộc.
- __Ngoại ngữ__: mình làm ở công ty Mỹ và làm việc với người nước ngoài hàng ngày nên ngoại ngữ, đặc biệt là nghe/nói (để họp) và viết (để chat), là bắt buộc. Ngoài ra, ngành phần mềm nói chung mình thấy tài liệu tiếng Anh là chủ yếu (và chuẩn nhất), nên nâng cao ngoại ngữ luôn không thừa.
- __Kỹ năng mềm__: DevOps phải tương tác với nhiều team khác nhau, nên cần kỹ năng giao tiếp hiệu quả. Vài ngày trước mình vừa bị sếp "mắng" vì nói chuyện với team dev nhưng lại giả định là họ đã nắm rõ bối cảnh của vấn đề, dùng những thuật ngữ mà họ chưa hiểu rõ, kết quả là cuộc nói chuyện dài dằng dặc và chỉ làm rõ được khi có sếp can thiệp.
- __Áp lực công việc__: DevOps thường phải đối mặt với các sự cố hệ thống có thể xảy ra bất cứ lúc nào, đòi hỏi khả năng làm việc dưới áp lực cao và sẵn sàng xử lý vấn đề ngoài giờ làm việc.
- __Cân bằng giữa tốc độ và ổn định__: Việc triển khai nhanh các thay đổi mới trong khi vẫn đảm bảo tính ổn định của hệ thống là một thách thức lớn.

### Cơ hội

- __Thu nhập__: Lương của DevOps được đánh giá là mức lương cao trong ngành IT, theo khảo sát của ITviec.
- __Cơ hội phát triển đa dạng__: DevOps có thể phát triển theo nhiều hướng khác nhau như Cloud Architecture, Site Reliability Engineering (SRE), Platform Engineering,...
- __Công nghệ đa dạng__: Được tiếp xúc với nhiều công nghệ mới và làm việc với nhiều đội nhóm khác nhau, giúp tích lũy kinh nghiệm đa dạng và đỡ  cảm thấy nhàm chán.

## FAQ

- __Cần học gì để làm DevOps engineer?__

  Mình thấy trang [roadmap.sh/devops](https://roadmap.sh/devops) tổng hợp rất trực quan và hợp lý. Về quan điểm cá nhân, có thể mình sẽ viết một bài sau.

- __Làm DevOps có cần ngoại ngữ không?__

  Không phải công ty nào cũng yêu cầu ngoại ngữ, nhưng theo mình là nên có. Tài liệu chủ yếu là ngoại ngữ, có ngoại ngữ cũng gia tăng cơ hội việc làm. Mình là một ví dụ về việc này. Mình gần như không biết gì khi bắt đầu intern, và sếp cũ của mình ở Fsoft bảo rằng: "Anh chọn mày vào vì mày có tiếng Anh. Với anh có thể train cho mày technical skill được, chứ không dạy mày tiếng Anh được. Và ở đây cần tiếng Anh để nói chuyện với khách." Ở công ty mới của mình cũng vậy, nếu không có tiếng Anh thì có lẽ mình đã bị loại từ vòng HR phỏng vấn.

- __Làm DevOps lương cao không?__

  Theo [khảo sát của ITviec](https://itviec.com/bao-cao/luong-it-va-thi-truong-tuyen-dung-it-vietnam#get-the-report), lương của DevOps thuộc hàng cao trong ngành IT. ![Khảo sát lương IT 2024-2025. Nguồn: ITviec](../assets/posts/2025-03-02-about-devops/img/vietnam-it-salary-report-2024-2025.png) <em> Khảo sát lương IT 2024-2025. Nguồn: ITviec </em>

- __Làm DevOps có phải code không?__

  Có. Tuy không yêu cầu ở mức khó như những bài Medium/Hard Leetcode, các dự án mình làm đều có những đầu việc cần code để giúp hệ thống hoạt động. Mình đặc biệt làm nhiều với public cloud, nên mình có những task code để tương tác với API của các public cloud này.

## Lời kết

DevOps là một vị trí đầy thách thức nhưng cũng rất thú vị trong ngành phát triển phần mềm. Với vai trò là cầu nối giữa nhiều team khác nhau và trách nhiệm đảm bảo quy trình phát triển - triển khai được trơn tru, DevOps engineer cần liên tục học hỏi và thích nghi với công nghệ mới.

Qua bài viết này, mình hy vọng đã giúp các bạn, đặc biệt là các bạn sinh viên và những người mới tìm hiểu, có cái nhìn thực tế hơn về DevOps. Dù còn nhiều khía cạnh chưa được đề cập đến, nhưng mình tin rằng đây là một điểm khởi đầu tốt để các bạn tìm hiểu sâu hơn về lĩnh vực này.

Nếu các bạn có thắc mắc hay góp ý gì, đừng ngần ngại để lại comment phía dưới nhé! 😊