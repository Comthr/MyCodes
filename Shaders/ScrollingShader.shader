Shader "ShaderCaseStudy/Ch02/ScrollingShader"
{
    Properties
    {
        _MainTint ("Diffuse Tint", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _ScrollingXSpeed("X Scrolling Speed",Float) = 2
        _ScrollingYSpeed("Y Scrolling Speed",Float) = 2
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _MainTint;
        sampler2D _MainTex;
        fixed _ScrollingXSpeed;
        fixed _ScrollingYSpeed;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed2 ScrolledUV = IN.uv_MainTex;
            fixed xScrollValue = _ScrollingXSpeed*_Time;
            fixed ySrollValue = _ScrollingXSpeed*_Time;
            ScrolledUV += fixed2(xScrollValue,ySrollValue);
            half4 c = tex2D(_MainTex,ScrolledUV);
            o.Albedo = c.rgb*_MainTint;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
