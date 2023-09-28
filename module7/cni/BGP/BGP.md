# BGP
> 路由协议
路由协议被分为EGP和IGP两个层次,没有EGP就不可能有世界上各个不同组织机构之间的通信,没有IGP机构内部也就不可能进行通信。下面我们就来看看EGP协议中的BGP协议是做什么的。

![Alt text](pic/image0.png)

> 自洽系统
BGP表示边界网关协议-Border Gateway Protocol，如同RIP、OSPF等IGP协议一样，也是一种路由协议。但与IGP所不同，它是自治系统AS之间的路由协议。那么什么是自治系统 (AS) ？
>
> 让我们设想一个场景，你和你的的朋友计划到张家界旅游。现在有两种出行的方式：你可以乘坐公共汽车或自驾前往。如果你打算乘高铁，那么就必须同意高铁的一些规则，比如说例如车费、停站次数、到达目的地的路线等。但是如果你选择自驾，就可以定义自己的行程。如下图所示。

![Alt text](pic/image1.png)

> 如上图所描述的，高铁和自驾小车的驾驶者都定义了他们自己的路由策略。在这里，我们就可以将高铁和小车看作为两个自治系统AS，它们拥有自己的Policy、管理条款，只要同意这些政策的任何用户都能成为该 AS 的一部分。因此，自治系统是受共同管理权限的设备的集合。因此，在 Internet 中，我们可以说一个电信服务商提供商 (ISP)下的客户创建一个 AS。


接下来，我们假设你的一位朋友决定在乘坐两站高铁后加入搭乘你的小车。在这种情况下，你就必须知道高铁所走的路线、第3次停靠的时间以及停留多长时间，以便可以顺利的接上你的朋友，这就需要你与处于高铁自治系统AS里的朋友进行互动，这样跨域通信就来了。

![Alt text](pic/image2.png)

如上图所示，我们的BGP就可以帮助你与你的朋友进行联系。可以认为你的朋友充分利用你的小车和高铁所定义Policy的优点。

因此，BGP是AS之间协议（在AS自治系统内则使用IGP 协议）。与IGP 路由协议不同，BGP不提供有关度量Metric或链路状态的路由，但它会选择涉及较少AS数量的一条路径。众所周知，互联网都是关于ISP的，BGP在这些ISP之间建立连接，并基于AS的策略Policy，通过BGP来选择控制路由。因此，BGP就是互联网协议。

通过上面的简单介绍，我们知道了BGP 是自治系统间AS协议，我们也知道什么是自治系统AS，下面我们继续看BGP协议的其他方面。如下图所示。

![Alt text](pic/image3.png)

从上面的网络拓扑可以看出，BGP分为内部BGP（iBGP）和外部 BGP（ eBGP）协议两种类型。连接两个AS间的路由器使用的是eBGP协议。而AS内部连接的路由器使用的是iBGP协议。AS域内的所有路由器都使用IGP协议，它们不知道运行iBGP的路由器。

另外，我们知道，在路由协议中，邻居的重要性也不言而喻，远亲不如近邻。在BGP网络中，当我们需要传递信息时。就需要识别邻居。以便对转发路由进行更新。在这里，我们需要知道，BGP中的邻居是必须手动配置的，但是它们之间并不要求必须是直接相连的。只要没有被识别定义为邻居，那么它们之间就不能传递信息。这就是为什么AS内的所有iBGP路由器都必须配置为彼此的邻居（如同全网Mesh连接），否则路由更新将不会发送给这些路由器。

在这里，来自邻居的路由更新将存储在本地BGP表中，来自该表的最佳路由被录入到路由表中。当然我们也可以假设与某个AS所有者正在进行冷战，不希望在我们的AS内允许通过那个AS的任何数据流。那么，就可以配置所属我们AS的属性、权重、本地优先级、AS 路径等来达成这个目的。并且还可以根据这些属性值，选择一条路由作为最佳路径。此外，如果有多个路径到达目的地，在这种情况下，属性也用于决定选择哪条路径。如下图所示。

![Alt text](pic/image4.png)

综上，BGP协议是一个非常重要的协议。它属于外部网关路由协议，可以实现自治系统间**无环路**的域间路由。BGP是沟通Internet广域网的主用路由协议。还是那句话：没有EGP就不可能有世界上各个不同组织机构之间的通信，只有BGP、IGP共同进行路由控制，才能够进行整个互联网的路由控制。


# BGP如何工作
BGP是一种路径矢量协议（Path vector protocol）的实现。因此，它的工作原理也是基于路径矢量。
首先说明一下，下面说的BGP route指的是BGP自己维护的路由信息，区分于设备的主路由表，也就是我们平常看见的那个路由表。
BGP route是BGP协议传输的数据，并存储在BGP router的数据库中。
并非所有的BGP route都会写到主路由表。
每条BGP route都包含了目的网络，下一跳和完整的路径信息。
路径信息是由AS号组成，当BGP router收到了一条 路由信息，如果里面的路径包含了自己的AS号，那它就能判定这是一条自己曾经发出的路由信息，收到的这条路由信息会被丢弃。

这里把每个BGP服务的实体叫做BGP router，而与BGP router连接的对端叫BGP peer。
每个BGP router在收到了peer传来的路由信息，会存储在自己的数据库，前面说过，路由信息包含很多其他的信息，BGP router会根据自己本地的policy结合路由信息中的内容判断，如果路由信息符合本地policy，BGP router会修改自己的主路由表。本地的policy可以有很多，举个例子，如果BGP router收到两条路由信息，目的网络一样，但是路径不一样，一个是AS1->AS3->AS5，另一个是AS1->AS2，如果没有其他的特殊policy，BGP router会选用AS1->AS2这条路由信息。
policy还有很多其他的，可以实现复杂的控制。

除了修改主路由表，BGP router还会修改这条路由信息，将自己的AS号加在BGP数据中，将下一跳改为自己，并且将自己加在路径信息里。
在这之后，这条消息会继续向别的BGP peer发送。而其他的BGP peer就知道了，可以通过指定下一跳到当前BGP router，来达到目的网络地址。
所以说，BGP更像是一个可达协议，可达信息传来传去，本地根据收到的信息判断决策，再应用到路由表。

唐增去西天取经，没经过一个地方，都会扣章，最后，形成一个拓扑图，只要每个地方都共享一份，那么就知道了所有地方在哪里了。