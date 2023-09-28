# 安装教程

> https://ohmyposh.dev/docs/

# BUGS

> ng: File C:\Users\admin\AppData\Roaming\npm\ng.ps1 cannot be loaded because running scripts is disabled on this system. For more information, see about_Execution_Policies at https:/go.microsoft.com/fwlink/?LinkID=135170.
>
> *At line:1* *char**:1*
>
> - *+ ng --v*
> - *+ ~~*
> - *+ CategoryInfo : SecurityError: (:) [], PSSecurityException*
> - *+ FullyQualifiedErrorId : unauthorized access*

> # How To Fix Error PS1 Can Not Be Loaded Because Running Scripts Is Disabled On This System In Angular

```PowerShell
set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

![img](https://f0eqwy0ght7.feishu.cn/space/api/box/stream/download/asynccode/?code=ZmM5OTZkNjM4ZTM0OGY2NjA3YjY3Zjk1YzhlODFlNmJfUU1mV1VJVXhZa0lFMkJhc28yMVJQeXk0T0lPd0FIZ0FfVG9rZW46RnB1Y2JydDZNb2xYYUJ4R0NlaGNrYktJbkdiXzE2OTU4MzQ3MDQ6MTY5NTgzODMwNF9WNA)

```PowerShell
Get-ExecutionPolicy
```

![img](https://f0eqwy0ght7.feishu.cn/space/api/box/stream/download/asynccode/?code=ZGI3NGY4MjhjZWNiYzBmYmUyZDQzYTFkMGIyNzc3YWVfWnkyczNTT3ZKZlJMVm5uRjMxS2RKY0gySFpzeHBzWUFfVG9rZW46SVVteWJUN09ub29udTl4OU1ITWNoajdRbnplXzE2OTU4MzQ3MDQ6MTY5NTgzODMwNF9WNA)

```PowerShell
Get-ExecutionPolicy -list
```

![img](https://f0eqwy0ght7.feishu.cn/space/api/box/stream/download/asynccode/?code=ZWVmMmNjMTYyZmQwYzJjMjU0NTBmNjM3YzQyYjdjZTVfbGNNWVpUSUV1b25qd1RkNGd2cEh2dHVtZ09zSDVPdDhfVG9rZW46WWZQRGJudHRpb1lSV2Z4M0xwYmNuWkxRbldoXzE2OTU4MzQ3MDQ6MTY5NTgzODMwNF9WNA)