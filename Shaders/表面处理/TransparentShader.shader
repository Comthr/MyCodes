Shader "ShaderCaseStudy/Ch02/TransparentShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags 
        { 
            "RenderType"="Transparent"  //标记当前材质为透明类型材质
            "IgnoreProjector" = "True"  //忽略Projector组件的影响
            "Queue" = "Transparent"     //渲染队列设置为"Transparent"
        }
        Cull Off                       //不做三角形的背面剔除
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard alpha:fade//设置透明度渲染模式

        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
        };
        sampler2D _MainTex;
        fixed4 _Color;
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
