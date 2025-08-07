Shader "ShaderCaseStudy/Ch02/RadiusShader"
{
    Properties
    {
        _Radius("Radius",Float) = 0.5
        _RadiusColor("Radius Color",Color) = (1,0,0,1)
        _RadiusWidth("Radius Width",Float) = 2
        _MainTex("Terrain Texture",2D) = ""{}
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
            float3 worldPos;
        };

        sampler2D _MainTex;
        float3 _Center;
        float _Radius;
        float4 _RadiusColor;
        float _RadiusWidth;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float d = distance(_Center,IN.worldPos);
            if(d> _Radius&& d<_Radius+_RadiusWidth)
                o.Albedo = _RadiusColor;
            else
                o.Albedo = tex2D(_MainTex,IN.uv_MainTex).rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
