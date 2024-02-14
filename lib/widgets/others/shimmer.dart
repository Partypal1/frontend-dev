import 'package:flutter/material.dart';

class Shimmer extends StatefulWidget {
  final LinearGradient gradient;
  final Widget child;
  const Shimmer({
    
    required this.gradient,
    required this.child,
    super.key});

  static ShimmerState? of(BuildContext context){
    return context.findAncestorStateOfType<ShimmerState>();
  }

  @override
  State<Shimmer> createState() => ShimmerState();
}

class ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  @override
  void initState(){
    super.initState();
    _controller = AnimationController.unbounded(vsync: this)
      ..repeat(min: -0.5, max: 1.5, period: const Duration(seconds: 1));
  }

  bool get isSized {
    return (context.findRenderObject() as RenderBox?)?.hasSize ?? false; 
  }

  Size get size{
    return (context.findRenderObject() as RenderBox).size;
  }

  LinearGradient get gradients {
    return LinearGradient(
      colors: widget.gradient.colors,
      stops: widget.gradient.stops,
      begin: widget.gradient.begin,
      end: widget.gradient.end,
      transform: SlideTransform(slidePercentage: _controller.value)
    );
  }

  Listenable get shimmerChanges{
    return _controller;
  }

  Offset getDescendantOffset(RenderBox descendant){
    RenderBox? shimmerBox = (context.findRenderObject() as RenderBox?);
    return descendant.localToGlobal(Offset.zero, ancestor: shimmerBox);
  }


  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}


class SlideTransform extends GradientTransform{
  final double slidePercentage;

  const SlideTransform({
    required this.slidePercentage
  });

  @override Matrix4? transform(Rect bounds, {TextDirection? textDirection}){
    return Matrix4.translationValues(slidePercentage * bounds.width, 0, 0);
  }
}


class ShimmerLoading extends StatefulWidget {
  final bool isLoading;
  final Widget? child;
  const ShimmerLoading({
    required this.isLoading,
    this.child,
    super.key});

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> {
  late Listenable? _shimmerChanges;
  @override
  void didChangeDependencies() {
    _shimmerChanges?.removeListener(_onShimmerChange);
    _shimmerChanges = Shimmer.of(context)?.shimmerChanges;
    _shimmerChanges?.addListener(_onShimmerChange);
    super.didChangeDependencies();
  }

  @override
  void initState(){
    super.initState();
    _shimmerChanges = Shimmer.of(context)?.shimmerChanges;
  }

  @override
  void dispose(){
    _shimmerChanges?.removeListener(_onShimmerChange);
    super.dispose();
  }

  void _onShimmerChange(){
    setState(() {
      
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if(!widget.isLoading){
      return widget.child ?? const SizedBox();
    }
    if(!Shimmer.of(context)!.isSized || context.findRenderObject() == null){
      return const SizedBox();
    }

    Size shimmerSize = Shimmer.of(context)!.size;
    Offset offsetInShimmer = Shimmer.of(context)!.getDescendantOffset((context.findRenderObject() as RenderBox));
    LinearGradient gradient = Shimmer.of(context)!.gradients;
    return ShaderMask(
      shaderCallback: (bounds){
        return gradient.createShader(
          Rect.fromLTWH(
            -offsetInShimmer.dx,
            -offsetInShimmer.dy,
            shimmerSize.width,
            shimmerSize.height
          )  
        );
      },
      child: widget.child,
    );
  }
}

const _shimmerGradient = LinearGradient(
   colors: [
    Color(0xFFEBEBF4),
    Color(0xFFF4F4F4),
    Color(0xFFEBEBF4),
  ],
  stops: [
    0.1,
    0.3,
    0.4,
  ],
  begin: Alignment(-1, -0.3),
  end: Alignment(1, 0.3),
  tileMode: TileMode.clamp,
);