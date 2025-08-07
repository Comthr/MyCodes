Shader "ShaderCaseStudy/Ch02/HolographicsShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _RimEffect("Rim Effect",Range(-1,1))= 0.25
    }
    SubShader
    {
        Tags 
        { 
            "RenderType"="Transparent"
            "IgnoreProjector" = "True"
            "Queue" = "Transparent"
        }
        LOD 200
        Cull Off
        Lighting Off//不计算光照
        CGPROGRAM
        #pragma surface surf Lambert alpha:fade

        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;  //贴图MainTex的uv坐标
            float3 worldNormal; //当前像素的世界空间法线向量
            float3 viewDir;     //世界空间视角方向
        };

        sampler2D _MainTex;
        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        float _RimEffect;

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            //视角方向和法线方向求点积
            //点积的绝对值结果是(0,1)，为0则表示在边缘。
            //这里的border可以看作是颜色系数，我们想要在边缘的时候系数反而更大一些
            float border = 1-abs(dot(IN.viewDir,IN.worldNormal));
            //差值运算。越靠近边界 alpha值越接近1，越远离边界，alpha值越靠近设置的强度
            float alpha = (border*(1-_RimEffect))+_RimEffect;
            o.Alpha = c.a*alpha;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
