Shader "ShaderCaseStudy/Ch05/NormalExtrusion"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _NormalMap("Normal Map",2D) = "bump"{}
        _ExtrusionAmount("Extrusion Amount",Range(-0.0001,0.0001)) = 0
        _ExtrusionMap("Extrusion Map",2D) = "bump"{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard vertex:vert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        sampler2D _NormalMap;
        sampler2D _ExtrusionMap;
        float _ExtrusionAmount;
        void vert(inout appdata_full v)
        {
            //对压缩纹理进行采样
            float4 tex = tex2Dlod(_ExtrusionMap,float4(v.texcoord.xy,0,0));
            //将0~1映射到 -1~1
            float extrusion = tex*2-1;
            v.vertex.xyz += v.normal*extrusion*_ExtrusionAmount;
        }
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            fixed3 normal = UnpackNormal(tex2D(_NormalMap,IN.uv_MainTex));
            o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Normal = normal;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
